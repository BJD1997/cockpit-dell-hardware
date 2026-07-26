<template>
<div class="card">
  <div class="card-header flex flex-row items-center justify-between">
    <h3 class="text-header text-default">Drives</h3>
    <div class="mt-3 sm:mt-0 sm:ml-4 flex items-center gap-2">
      <button type="button" class="card-refresh-btn" :disabled="loading" @click="loadDrives()">
        <RefreshIconOutline class="h-5 w-5" aria-hidden="true" />
      </button>
    </div>
  </div>
  <div class="card-body">
    <div class="mt-2 flex flex-col">
      <div class="-my-2 -mx-4 overflow-x-auto overflow-y-auto max-h-96 sm:-mx-6 lg:-mx-8">
        <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
          <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
            <table class="min-w-full divide-y divide-default">
              <thead class="bg-accent">
                <tr>
                  <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold sm:pl-6">Device</th>
                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold">Model</th>
                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold">Family</th>
                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold">Serial</th>
                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold">Size</th>
                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold">Firmware</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-default bg-default">
                <tr v-if="loading">
                  <td colspan="6" class="py-4 text-center text-sm text-muted">Loading drives...</td>
                </tr>
                <tr v-else-if="drives.length === 0">
                  <td colspan="6" class="py-4 text-center text-sm text-muted">No drives detected</td>
                </tr>
                <tr v-for="drive in drives" :key="drive.device">
                  <td class="whitespace-nowrap py-3 pl-4 pr-3 text-sm font-medium text-default sm:pl-6">/dev/{{ drive.device }}</td>
                  <td class="whitespace-nowrap px-3 py-3 text-sm text-default">{{ drive.model || '—' }}</td>
                  <td class="whitespace-nowrap px-3 py-3 text-sm text-muted">{{ drive.family || '—' }}</td>
                  <td class="whitespace-nowrap px-3 py-3 text-xs text-muted font-mono">{{ drive.serial || '—' }}</td>
                  <td class="whitespace-nowrap px-3 py-3 text-sm text-default">{{ drive.size }}</td>
                  <td class="whitespace-nowrap px-3 py-3 text-sm font-mono text-default">{{ drive.firmware || '—' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import { RefreshIcon as RefreshIconOutline } from "@heroicons/vue/outline";
import { ref, onMounted } from "vue";
import { server, Command, unwrap } from "@45drives/houston-common-lib";

export default {
  components: { RefreshIconOutline },
  setup() {
    const drives = ref([]);
    const loading = ref(false);

    const loadDrives = async () => {
      loading.value = true;
      drives.value = [];
      try {
        const proc = await unwrap(server.execute(
          new Command(["lsblk", "-J", "-o", "NAME,MODEL,SERIAL,TYPE,SIZE,REV", "-d"], { superuser: "try" })
        ));
        const data = JSON.parse(proc.getStdout());
        const blockdevices = data.blockdevices || [];
        const driveList = blockdevices
          .filter(d => d.type === "disk")
          .map(d => ({
            device: d.name,
            model: (d.model || "").trim(),
            serial: (d.serial || "").trim(),
            size: d.size || "",
            firmware: (d.rev || "").trim(),
            family: "",
          }));

        // Family isn't in lsblk output - query smartctl for it directly.
        const missingFamily = driveList.filter(d => d.device);
        if (missingFamily.length > 0) {
          const devArgs = missingFamily.map(d => `/dev/${d.device}`).join(" ");
          try {
            const smartProc = await unwrap(server.execute(
              new Command(["bash", "-c", `for d in ${devArgs}; do echo "===DEV===$d"; smartctl -i "$d" 2>/dev/null | grep -E "^(Model Family|Product):" || true; done`], { superuser: "try" })
            ));
            const smartOut = smartProc.getStdout();
            let currentDev = "";
            for (const line of smartOut.split("\n")) {
              if (line.startsWith("===DEV===")) {
                currentDev = line.replace("===DEV===", "").replace("/dev/", "").trim();
              } else if (line.includes(":") && currentDev) {
                const val = line.split(":").slice(1).join(":").trim();
                if (val) {
                  const drive = driveList.find(d => d.device === currentDev);
                  if (drive && !drive.family) {
                    drive.family = val;
                  }
                }
              }
            }
          } catch (e) {
            console.log("smartctl family fallback failed:", e);
          }
        }

        drives.value = driveList;
      } catch (e) {
        console.error("Failed to load drives:", e);
      }
      loading.value = false;
    };

    onMounted(() => {
      loadDrives();
    });

    return {
      drives,
      loading,
      loadDrives,
    };
  },
};
</script>
