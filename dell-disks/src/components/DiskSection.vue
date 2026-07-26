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
        v-if="currentDisk && diskObj['bay-id']"
        class="grid grid-cols-2 2xl:grid-cols-3 grid-flow-row-dense grow"
      >
        <div class="grid grid-cols-1 self-start py-1 md:py-2 px-2">
          <div class="text-sm text-muted">Device</div>
          <div class="text-sm break-words">{{ diskObj["bay-id"] }}</div>
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

export default {
  setup() {
    const currentDisk = inject("currentDisk");
    const diskInfo = inject("diskInfo");
    const wMsg = ref("Click on a disk for more detail.");
    const diskObj = reactive({});

    const updateDiskObj = () => {
      if (!currentDisk.value || !diskInfo.rows) return;
      const tmpObj = diskInfo.rows.find((slot) => slot["bay-id"] === currentDisk.value);
      if (!tmpObj) {
        console.log(`Unable to find info for disk "${currentDisk.value}"`);
        return;
      }
      Object.assign(diskObj, tmpObj);
    };

    watch(currentDisk, updateDiskObj);
    watch(diskInfo, updateDiskObj);

    return {
      wMsg,
      currentDisk,
      diskObj,
      diskInfo,
    };
  },
};
</script>
