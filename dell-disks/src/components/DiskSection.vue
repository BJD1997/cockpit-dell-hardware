<template>
  <div id="diskInfoCard" class="card self-stretch flex-auto flex flex-col min-h-[22rem]">
    <div class="card-header">
      <h3 class="text-header text-default">Disk Information</h3>
    </div>
    <div
      id="disk-section-card-body"
      :class="[currentDisk ? '' : 'grow', 'card-body flex flex-wrap justify-start']"
    >
      <div
        id="diskInfoTable"
        v-if="currentDisk && diskObj['id']"
        class="grid grid-cols-2 2xl:grid-cols-3 grid-flow-row-dense grow"
      >
        <div class="grid grid-cols-1 self-start py-1 md:py-2 px-2">
          <div class="text-sm text-muted">Device</div>
          <div class="text-sm break-words">{{ diskObj["id"] }}</div>
        </div>
        <div
          v-if="diskObj['bay-id'] !== null && diskObj['bay-id'] !== undefined"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Bay</div>
          <div class="text-sm break-words flex items-center gap-2">
            Bay {{ diskObj["bay-id"] }}
            <button
              type="button"
              :disabled="locating === 'busy'"
              @click="toggleLocate"
              class="text-xs rounded px-2 py-0.5 border border-default hover:bg-accent disabled:opacity-50"
              :class="locating === 'on' ? 'text-amber-600 dark:text-amber-400 border-amber-500' : 'text-muted'"
            >
              {{ locating === "on" ? "Stop Blinking" : "Blink LED" }}
            </button>
          </div>
        </div>
        <div v-if="diskObj['dev']" class="grid grid-cols-1 self-start py-1 md:py-2 px-2">
          <div class="text-sm text-muted">Device Path</div>
          <div class="text-sm break-words">{{ diskObj["dev"] }}</div>
        </div>
        <div
          v-if="diskObj['disk_type']"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Disk Type</div>
          <div class="text-sm break-words">{{ diskObj["disk_type"] }}</div>
        </div>
        <div
          v-if="diskObj['transport'] && diskObj['transport'] !== '?'"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Transport</div>
          <div class="text-sm break-words">{{ diskObj["transport"] }}</div>
        </div>
        <div
          v-if="diskObj['vendor'] && diskObj['vendor'] !== '?'"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Vendor</div>
          <div class="text-sm break-words">{{ diskObj["vendor"] }}</div>
        </div>
        <div
          v-if="diskObj['model-name'] && diskObj['model-name'] !== '?'"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Model Name</div>
          <div class="text-sm break-words">{{ diskObj["model-name"] }}</div>
        </div>
        <div
          v-if="diskObj['serial'] && diskObj['serial'] !== '?'"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Serial</div>
          <div class="text-sm break-words">{{ diskObj["serial"] }}</div>
        </div>
        <div
          v-if="diskObj['capacity']"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Capacity</div>
          <div class="text-sm break-words">{{ diskObj["capacity"] }}</div>
        </div>
        <div
          v-if="diskObj['firm-ver'] && diskObj['firm-ver'] !== '?'"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Firmware Version</div>
          <div class="text-sm break-words">{{ diskObj["firm-ver"] }}</div>
        </div>
        <div
          v-if="diskObj['rotation-rate']"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Rotation Rate</div>
          <div class="text-sm break-words">{{ diskObj["rotation-rate"] }} RPM</div>
        </div>
        <div
          v-if="diskObj['power-cycle-count'] !== null && diskObj['power-cycle-count'] !== undefined"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Power Cycle Count</div>
          <div class="text-sm break-words">{{ diskObj["power-cycle-count"] }}</div>
        </div>
        <div
          v-if="diskObj['temp-c'] !== null && diskObj['temp-c'] !== undefined"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Temperature</div>
          <div class="text-sm break-words">
            {{ diskObj["temp-c"] }} °C / {{ (diskObj["temp-c"] * (9 / 5) + 32).toFixed(1) }} °F
          </div>
        </div>
        <div
          v-if="diskObj['current-pending-sector'] && diskObj['current-pending-sector'] !== '0'"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Current Pending Sector</div>
          <div class="text-sm break-words">{{ diskObj["current-pending-sector"] }}</div>
        </div>
        <div
          v-if="diskObj['offline-uncorrectable'] && diskObj['offline-uncorrectable'] !== '0'"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Offline Uncorrectable</div>
          <div class="text-sm break-words">{{ diskObj["offline-uncorrectable"] }}</div>
        </div>
        <div
          v-if="diskObj['power-on-time'] !== null && diskObj['power-on-time'] !== undefined"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Power On Time</div>
          <div class="text-sm break-words">{{ diskObj["power-on-time"] }} h</div>
        </div>
        <div
          v-if="diskObj['health']"
          class="grid grid-cols-1 self-start py-1 md:py-2 px-2"
        >
          <div class="text-sm text-muted">Health</div>
          <div
            class="text-sm break-words"
            :class="{
              'text-green-600 dark:text-green-400': diskObj['health'] === 'PASSED',
              'text-red-600 dark:text-red-400': diskObj['health'] === 'FAILED',
            }"
          >
            {{ diskObj["health"] }}
          </div>
        </div>
      </div>
      <div v-else class="grow flex justify-center items-center">
        <div class="p-5 bg-accent rounded-lg">
          <span class="text-muted">{{ wMsg }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch, inject, reactive } from "vue";
import { legacy } from "@45drives/houston-common-lib";
const { useSpawn, errorStringHTML } = legacy;
import { pushNotification, Notification } from "@45drives/houston-common-ui";

export default {
  setup() {
    const currentDisk = inject("currentDisk");
    const diskInfo = inject("diskInfo");
    const wMsg = ref("Click on a disk for more detail.");
    const diskObj = reactive({});
    const locating = ref("off"); // "off" | "on" | "busy"

    const updateDiskObj = () => {
      if (!currentDisk.value || !diskInfo.rows) return;
      const tmpObj = diskInfo.rows.find((slot) => slot["id"] === currentDisk.value);
      if (!tmpObj) {
        console.log(`Unable to find info for disk "${currentDisk.value}"`);
        return;
      }
      Object.assign(diskObj, tmpObj);
    };

    watch(currentDisk, () => {
      locating.value = "off";
      updateDiskObj();
    });
    watch(diskInfo, updateDiskObj);

    const toggleLocate = async () => {
      if (diskObj["bay-id"] === null || diskObj["bay-id"] === undefined) return;
      const nextState = locating.value === "on" ? "off" : "on";
      locating.value = "busy";
      try {
        await useSpawn(
          [
            "/usr/share/cockpit/dell-disks/scripts/disk_locate",
            String(diskObj["bay-id"]),
            nextState,
          ],
          { err: "out", superuser: "require" }
        ).promise();
        locating.value = nextState;
      } catch (error) {
        console.log(error);
        locating.value = locating.value === "busy" ? "off" : locating.value;
        pushNotification(
          new Notification(
            "Unable to set locate LED",
            errorStringHTML(error),
            "error"
          )
        );
      }
    };

    return {
      wMsg,
      currentDisk,
      diskObj,
      diskInfo,
      locating,
      toggleLocate,
    };
  },
};
</script>
