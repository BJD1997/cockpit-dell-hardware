<script>
import "@fontsource/red-hat-text/600.css";
import "@fontsource/red-hat-text/400.css";
import DellHeader from "./components/DellHeader.vue";
import { ref, reactive, provide, onMounted } from "vue";
import ServerSection from "./components/ServerSection.vue";
import DiskSection from "./components/DiskSection.vue";
import ChassisFront from "./components/ChassisFront.vue";
import { legacy } from "@45drives/houston-common-lib";
const { useSpawn, errorStringHTML } = legacy;
import { pushNotification, Notification, NotificationView } from "@45drives/houston-common-ui";

export default {
  name: "App",
  components: {
    DellHeader,
    ServerSection,
    DiskSection,
    ChassisFront,
    NotificationView,
  },
  setup() {
    const currentDisk = ref("");
    provide("currentDisk", currentDisk);
    const diskInfo = reactive({});
    provide("diskInfo", diskInfo);

    const adminFlag = ref(false);
    const adminCheck = ref(false);

    const preloadChecks = reactive({
      serverInfo: {
        content: reactive({}),
        finished: false,
        failed: false,
      },
      diskInfo: {
        content: reactive({}),
        finished: false,
        failed: false,
      },
    });

    const runServerInfo = async () => {
      preloadChecks.serverInfo.finished = false;
      try {
        const state = await useSpawn(
          ["/usr/share/cockpit/dell-disks/scripts/server_info"],
          {
            err: "out",
            superuser: "require",
          }
        ).promise();
        let result = JSON.parse(state.stdout);
        preloadChecks.serverInfo.content = result;
        preloadChecks.serverInfo.finished = true;
        preloadChecks.serverInfo.failed = false;
      } catch (error) {
        console.log(error);
        preloadChecks.serverInfo.content = null;
        preloadChecks.serverInfo.finished = true;
        preloadChecks.serverInfo.failed = true;
        pushNotification(
          new Notification(
            "Error obtaining server information",
            errorStringHTML(error),
            "error",
            "never"
          )
        );
      }
    };

    const runDiskInfo = async () => {
      preloadChecks.diskInfo.finished = false;
      try {
        const state = await useSpawn(
          ["/usr/share/cockpit/dell-disks/scripts/disk_info"],
          {
            err: "out",
            superuser: "require",
          }
        ).promise();
        let result = JSON.parse(state.stdout);
        Object.assign(diskInfo, result);
        preloadChecks.diskInfo.content = result;
        preloadChecks.diskInfo.finished = true;
        preloadChecks.diskInfo.failed = false;
      } catch (error) {
        console.log(error);
        preloadChecks.diskInfo.content = null;
        preloadChecks.diskInfo.failed = true;
        preloadChecks.diskInfo.finished = true;
        pushNotification(
          new Notification(
            "Error obtaining disk information",
            errorStringHTML(error),
            "error"
          )
        );
      }
    };

    const refresh = async () => {
      await Promise.all([runServerInfo(), runDiskInfo()]);
    };

    const init = async () => {
      await refresh();
    };

    const rootCheck = async () => {
      let root_check = cockpit.permission({ admin: true });
      root_check.addEventListener("changed", () => {
        if (root_check.allowed) {
          adminCheck.value = true;
          adminFlag.value = true;
          init();
        } else {
          adminCheck.value = true;
          adminFlag.value = false;
        }
      });
    };

    onMounted(() => {
      rootCheck();
    });

    return {
      adminCheck,
      adminFlag,
      preloadChecks,
      diskInfo,
      refresh,
    };
  },
};
</script>

<template>
  <NotificationView />
  <div id="App" class="flex flex-col h-full">
    <DellHeader moduleName="Disks" />
    <div
      v-if="
        adminCheck &&
        adminFlag &&
        preloadChecks.serverInfo.finished &&
        preloadChecks.diskInfo.finished &&
        !preloadChecks.serverInfo.failed &&
        !preloadChecks.diskInfo.failed
      "
      class="grow flex flex-col well overflow-y-auto p-4"
    >
      <div class="gap-well grid grid-cols-6">
        <div class="grow grid gap-well col-span-6 lg:col-span-3">
          <ChassisFront :rows="diskInfo.rows ?? []" @refresh="refresh" />
        </div>

        <div class="grow grid gap-well col-span-6 lg:col-span-3">
          <DiskSection />
        </div>

        <div class="flex grow flex-col items-stretch gap-well col-span-6">
          <ServerSection :serverInfo="preloadChecks.serverInfo.content" />
        </div>
      </div>
    </div>
    <div
      v-else-if="adminCheck && adminFlag"
      class="flex-auto flex flex-col items-center justify-evenly well"
    >
      <div
        v-if="!preloadChecks.serverInfo.finished || !preloadChecks.diskInfo.finished"
      >
        Gathering disk information. Please wait...
      </div>
      <div
        v-if="
          (preloadChecks.serverInfo.finished && preloadChecks.serverInfo.failed) ||
          (preloadChecks.diskInfo.finished && preloadChecks.diskInfo.failed)
        "
        class="well flex flex-col items-center h-full"
      >
        <div class="card">
          <div class="card-header">
            <h3 class="text-header text-default">Dell Disks - Unable to proceed</h3>
          </div>
          <div class="card-body flex flex-col gap-4">
            <h3>This module requires smartmontools and dmidecode to be installed.</h3>
            <div>Consult any notifications for potential fixes.</div>
          </div>
        </div>
      </div>
    </div>
    <div
      v-else-if="adminCheck && !adminFlag"
      class="grow flex flex-col well overflow-y-auto p-4 justify-center items-center"
    >
      <div class="card">
        <div class="card-header">
          <h3 class="text-header text-default">Administrative Access Required</h3>
        </div>
        <div class="card-body flex flex-col gap-4">
          <div class="bg-accent rounded-md p-5 flex flex-col items-center gap-4">
            Dell Disks requires administrative access to proceed.
          </div>
        </div>
      </div>
    </div>
    <div
      v-else
      class="grow flex flex-col well overflow-y-auto p-4 justify-center items-center"
    >
      Loading ...
    </div>
  </div>
</template>

<style>
@import "@45drives/houston-common-css/src/index.css";
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  margin: 0;
  @apply bg-default h-full text-default;
}
</style>
