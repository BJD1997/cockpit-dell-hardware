<template>
  <div class="card mt-2">
    <div
      class="card-header card-header flex flex-row items-center justify-between"
    >
      <h3 class="text-header text-default">System</h3>
      <div class="mt-3 sm:mt-0 sm:ml-4">
        <button type="button" class="card-refresh-btn" @click="getSystemInfo()">
          <RefreshIconOutline class="h-5 w-5" aria-hidden="true" />
        </button>
      </div>
    </div>
    <div class="card-body">
      <div v-if="!fatalError" class="bg-default shadow overflow-hidden sm:rounded-lg">
        <div class="border-b border-default">
          <dl>
            <div
              class="bg-accent px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6"
            >
              <dt class="text-sm font-medium">Manufacturer</dt>
              <dd class="mt-1 text-sm text-muted sm:mt-0 sm:col-span-2">
                {{ sysManufacturer }}
              </dd>
            </div>
            <div
              class="bg-default px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6"
            >
              <dt class="text-sm font-medium">Model</dt>
              <dd class="mt-1 text-sm text-muted sm:mt-0 sm:col-span-2">
                {{ sysModel }}
              </dd>
            </div>
            <div
              class="bg-accent px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6"
            >
              <dt class="text-sm font-medium">Service Tag</dt>
              <dd class="mt-1 text-sm text-muted sm:mt-0 sm:col-span-2">
                {{ sysSerial }}
              </dd>
            </div>
            <div
              class="bg-default px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6"
            >
              <dt class="text-sm font-medium">Motherboard</dt>
              <dd class="mt-1 text-sm text-muted sm:mt-0 sm:col-span-2">
                {{ moboModel }}
              </dd>
            </div>
            <div
              class="bg-accent px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6"
            >
              <dt class="text-sm font-medium">Motherboard Serial</dt>
              <dd class="mt-1 text-sm text-muted sm:mt-0 sm:col-span-2">
                {{ moboSerial }}
              </dd>
            </div>
            <div
              class="bg-default px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6"
            >
              <dt class="text-sm font-medium">BIOS Version</dt>
              <dd class="mt-1 text-sm text-muted sm:mt-0 sm:col-span-2">
                {{ biosVersion }} ({{ biosDate }})
              </dd>
            </div>
          </dl>
        </div>
      </div>
      <div v-if="fatalError">
        <ErrorMessage :errorMsg="fatalErrorMsg" :FixButton="false" />
      </div>
    </div>
  </div>
</template>

<script>
import { RefreshIcon as RefreshIconOutline } from "@heroicons/vue/outline";
import { ref } from "vue";
import ErrorMessage from "./ErrorMessage.vue";
import { server, Command, unwrap } from "@45drives/houston-common-lib";

export default {
  components: {
    RefreshIconOutline,
    ErrorMessage,
  },
  setup() {
    const sysManufacturer = ref("");
    const sysModel = ref("");
    const sysSerial = ref("");
    const moboModel = ref("");
    const moboSerial = ref("");
    const biosVersion = ref("");
    const biosDate = ref("");
    const fatalError = ref(false);
    const fatalErrorMsg = ref([]);

    const getSystemInfo = async () => {
      sysManufacturer.value = "Loading...";
      sysModel.value = "Loading...";
      sysSerial.value = "Loading...";
      moboModel.value = "Loading...";
      moboSerial.value = "Loading...";
      try {
        const proc = await unwrap(
          server.execute(
            new Command(["/usr/share/cockpit/dell-system/scripts/server_info"], {
              superuser: "require",
            })
          )
        );
        const sysInfo = JSON.parse(proc.getStdout());
        sysManufacturer.value = sysInfo["Manufacturer"];
        sysModel.value = sysInfo["Model"];
        sysSerial.value = sysInfo["Serial"];
        moboModel.value = sysInfo["Motherboard"];
        moboSerial.value = sysInfo["Motherboard Serial"];
        biosVersion.value = sysInfo["BIOS Version"];
        biosDate.value = sysInfo["BIOS Release Date"];
        fatalError.value = false;
      } catch (err) {
        console.log(err);
        fatalError.value = true;
        fatalErrorMsg.value = [
          "An error occurred while gathering system information.",
          "This requires dmidecode to be installed.",
        ];
      }
    };

    getSystemInfo();

    return {
      sysManufacturer,
      sysModel,
      sysSerial,
      moboModel,
      moboSerial,
      biosVersion,
      biosDate,
      getSystemInfo,
      fatalError,
      fatalErrorMsg,
    };
  },
};
</script>
