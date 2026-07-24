<template>
  <div class="card grow flex flex-col">
    <div class="card-header">
      <h3 class="text-header text-default">Server</h3>
    </div>
    <div class="card-body grow flex">
      <div class="grow flex flex-col items-stretch">
        <div class="mt-0">
          <dl class="sm:divide-y divide-default divide-y">
            <div class="py-2 sm:py-2 sm:grid sm:grid-cols-5 sm:gap-4 grid grid-cols-2">
              <dt class="text-sm font-medium text-muted">Manufacturer</dt>
              <dd class="mt-1 text-sm sm:mt-0 sm:col-span-4 col-span-2">
                {{ serverInfo.Manufacturer }}
              </dd>
            </div>

            <div class="py-2 sm:py-2 sm:grid sm:grid-cols-5 sm:gap-4 grid grid-cols-2">
              <dt class="text-sm font-medium text-muted">Model</dt>
              <dd class="mt-1 text-sm sm:mt-0 sm:col-span-4 col-span-2">
                {{ serverInfo.Model }}
              </dd>
            </div>

            <div class="py-2 sm:py-2 sm:grid sm:grid-cols-5 sm:gap-4 grid grid-cols-2">
              <dt class="text-sm font-medium text-muted">Service Tag</dt>
              <dd class="mt-1 text-sm sm:mt-0 sm:col-span-4 col-span-2">
                {{ serverInfo.Serial }}
              </dd>
            </div>

            <div class="py-2 sm:py-2 sm:grid sm:grid-cols-5 sm:gap-4 grid grid-cols-2">
              <dt class="text-sm font-medium text-muted">BIOS Version</dt>
              <dd class="mt-1 text-sm sm:mt-0 sm:col-span-4 col-span-2">
                {{ serverInfo["BIOS Version"] }} ({{ serverInfo["BIOS Release Date"] }})
              </dd>
            </div>

            <div class="py-2 sm:py-2 sm:grid sm:grid-cols-5 sm:gap-4 grid grid-cols-2">
              <dt class="text-sm font-medium text-muted">Disk Count</dt>
              <dd class="mt-1 text-sm sm:mt-0 sm:col-span-4 col-span-2">
                {{ diskCount }}
              </dd>
            </div>

            <div class="py-2 sm:py-2 sm:grid sm:grid-cols-5 sm:gap-4 grid grid-cols-2">
              <dt class="text-sm font-medium text-muted">Total Storage</dt>
              <dd class="mt-1 text-sm sm:mt-0 sm:col-span-4 col-span-2">
                {{ storageCapacityStr }}
              </dd>
            </div>

            <div class="py-2 sm:py-2 sm:grid sm:grid-cols-5 sm:gap-4 grid grid-cols-2">
              <dt class="text-sm font-medium text-muted">Disk Temperature (avg)</dt>
              <dd class="mt-1 text-sm sm:mt-0 sm:col-span-4 col-span-2">
                {{ avgTempStr }}
              </dd>
            </div>
          </dl>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch, inject } from "vue";

export default {
  props: {
    serverInfo: Object,
  },
  setup() {
    const diskInfo = inject("diskInfo");
    const diskCount = ref(0);
    const storageCapacityStr = ref("Loading ...");
    const avgTempStr = ref("Loading...");

    const getCapacityGB = (capacityStr) => {
      const coeffLut = { TB: 1000, GB: 1, MB: 0.001 };
      if (!capacityStr) return 0;
      const [value, unit] = capacityStr.split(" ");
      return Number(value) * (coeffLut[unit] ?? 0);
    };

    const updateDiskSummary = () => {
      if (!diskInfo.rows) return;
      const disks = diskInfo.rows;
      diskCount.value = disks.length;

      if (diskCount.value === 0) {
        storageCapacityStr.value = "No Disks Present";
        avgTempStr.value = "No Disks Present";
        return;
      }

      const storageCapacity = disks
        .map((disk) => getCapacityGB(disk.capacity))
        .reduce((total, cap) => total + cap, 0);
      storageCapacityStr.value =
        storageCapacity > 1000
          ? (storageCapacity / 1000).toFixed(2) + " TB"
          : storageCapacity.toFixed(2) + " GB";

      const temps = disks
        .map((disk) => disk["temp-c"])
        .filter((temp) => temp !== null && temp !== undefined);
      if (temps.length) {
        const avgTemp = temps.reduce((total, temp) => total + temp, 0) / temps.length;
        avgTempStr.value = `${avgTemp.toFixed(1)} °C / ${(avgTemp * (9 / 5) + 32).toFixed(1)} °F`;
      } else {
        avgTempStr.value = "Unavailable";
      }
    };

    watch(diskInfo, updateDiskSummary);

    return {
      diskCount,
      storageCapacityStr,
      avgTempStr,
    };
  },
};
</script>
