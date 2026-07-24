<template>
  <div id="chassis-card" class="card grow flex flex-col">
    <div class="card-header flex items-center justify-between">
      <h3 class="text-header text-default">Disk Viewer</h3>
      <button
        @click="$emit('refresh')"
        type="button"
        class="text-sm text-muted hover:text-default focus:outline-none flex items-center gap-1"
      >
        <RefreshIconOutline class="size-icon" />
        Refresh
      </button>
    </div>
    <div class="card-body grow flex flex-col items-center justify-center gap-2 p-4">
      <svg viewBox="0 0 840 200" class="w-full h-auto max-w-3xl" role="img" aria-label="PowerEdge R330 front bay layout">
        <rect x="1" y="1" width="838" height="198" rx="10" class="fill-neutral-800 stroke-neutral-600" stroke-width="2" />
        <rect x="8" y="8" width="16" height="184" rx="3" class="fill-neutral-700" />
        <rect x="816" y="8" width="16" height="184" rx="3" class="fill-neutral-700" />

        <g
          v-for="(bay, i) in bays"
          :key="bay.label"
          @click="bay.disk && (currentDisk = bay.disk['bay-id'])"
          :class="bay.disk ? 'cursor-pointer' : ''"
        >
          <rect
            :x="40 + i * 190"
            y="20"
            width="170"
            height="150"
            rx="6"
            :class="[
              'stroke-2 transition-colors',
              bay.disk ? bayFillClass(bay.disk.health) : 'fill-neutral-900',
              bay.disk && currentDisk === bay.disk['bay-id'] ? 'stroke-blue-500' : 'stroke-neutral-600',
              !bay.disk ? 'stroke-dashed' : '',
            ]"
            :stroke-dasharray="bay.disk ? '0' : '6 4'"
          />
          <rect
            v-for="vent in 4"
            :key="vent"
            :x="52 + i * 190"
            :y="34 + vent * 12"
            width="146"
            height="4"
            rx="2"
            class="fill-neutral-700 opacity-60"
          />
          <circle
            v-if="bay.disk"
            :cx="55 + i * 190"
            cy="152"
            r="6"
            :class="ledClass(bay.disk.health)"
          />
          <text
            :x="125 + i * 190"
            y="190"
            text-anchor="middle"
            class="text-xs fill-neutral-300"
          >{{ bay.label }}</text>
        </g>
      </svg>
      <div class="text-xs text-muted text-center max-w-3xl">
        Bay order reflects OS device enumeration order, not a verified physical slot mapping.
      </div>
    </div>
  </div>
</template>

<script>
import { RefreshIcon as RefreshIconOutline } from "@heroicons/vue/outline";
import { computed, inject } from "vue";

const BAY_COUNT = 4;

export default {
  components: {
    RefreshIconOutline,
  },
  props: {
    rows: {
      type: Array,
      default: () => [],
    },
  },
  emits: ["refresh"],
  setup(props) {
    const currentDisk = inject("currentDisk");

    const bays = computed(() =>
      Array.from({ length: BAY_COUNT }, (_, i) => ({
        label: `Bay ${i}`,
        disk: props.rows[i] ?? null,
      }))
    );

    const bayFillClass = (health) => {
      if (health === "PASSED") return "fill-neutral-700";
      if (health === "FAILED") return "fill-red-900";
      return "fill-neutral-700";
    };
    const ledClass = (health) => {
      if (health === "PASSED") return "fill-green-500";
      if (health === "FAILED") return "fill-red-500";
      return "fill-gray-400";
    };

    return {
      currentDisk,
      bays,
      bayFillClass,
      ledClass,
    };
  },
};
</script>
