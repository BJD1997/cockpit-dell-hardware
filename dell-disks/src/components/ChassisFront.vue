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
      <svg viewBox="0 0 2866 422" class="w-full h-auto max-w-6xl" role="img" aria-label="PowerEdge R330 front panel">
        <defs>
          <linearGradient id="body" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0" stop-color="#33373d" />
            <stop offset=".18" stop-color="#17191d" />
            <stop offset=".56" stop-color="#22252b" />
            <stop offset="1" stop-color="#0e1014" />
          </linearGradient>
          <linearGradient id="bay" x1="0" x2="1" y1="0" y2="1">
            <stop offset="0" stop-color="#747982" />
            <stop offset=".35" stop-color="#2e3239" />
            <stop offset=".7" stop-color="#565b64" />
            <stop offset="1" stop-color="#17191e" />
          </linearGradient>
          <linearGradient id="handle" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0" stop-color="#585d66" />
            <stop offset=".5" stop-color="#16191f" />
            <stop offset="1" stop-color="#08090c" />
          </linearGradient>
          <linearGradient id="screen" x1="0" x2="1" y1="0" y2="0">
            <stop offset="0" stop-color="#1138d9" />
            <stop offset=".55" stop-color="#2149ff" />
            <stop offset="1" stop-color="#081074" />
          </linearGradient>
          <filter id="softShadow" x="-10%" y="-30%" width="120%" height="180%">
            <feDropShadow dx="0" dy="6" stdDeviation="7" flood-color="#000" flood-opacity=".35" />
          </filter>
          <pattern id="topSlots" width="28" height="24" patternUnits="userSpaceOnUse">
            <rect width="28" height="24" fill="#08090c" />
            <rect x="4" y="4" width="16" height="12" rx="1.5" fill="#2b2f36" />
          </pattern>
          <pattern id="mesh" width="42" height="36" patternUnits="userSpaceOnUse">
            <path d="M11 2h20l10 16-10 16H11L1 18Z" fill="none" stroke="#68707b" stroke-width="5" />
          </pattern>
          <g id="driveGrillBars" stroke-linecap="butt">
            <path d="M183 42v84M222 42v84M261 42v84M300 42v84M339 42v84M378 42v84" stroke="#aab0b8" stroke-width="10" />
            <path d="M188 42v84M227 42v84M266 42v84M305 42v84M344 42v84M383 42v84" stroke="#4a5059" stroke-width="3" opacity=".55" />
          </g>
          <style>
            .stroke{stroke:#08090c;stroke-width:4;stroke-linejoin:round}
            .fine{stroke:#9aa1aa;stroke-width:2;stroke-linecap:round;opacity:.45}
            .label{font-family:Arial, Helvetica, sans-serif;font-weight:700;letter-spacing:.02em}
            .tiny{font-family:Arial, Helvetica, sans-serif;font-weight:700}
          </style>
        </defs>

        <g filter="url(#softShadow)">
          <rect x="86" y="86" width="2694" height="226" rx="15" fill="url(#body)" />
          <rect x="88" y="88" width="2690" height="222" rx="12" fill="none" stroke="#616873" stroke-width="3" opacity=".7" />

          <g id="left-ear">
            <rect x="86" y="90" width="143" height="218" rx="7" fill="url(#handle)" class="stroke" />
            <rect x="94" y="106" width="100" height="178" rx="5" fill="#20242b" />
            <path d="M100 110h87M101 118h86" class="fine" />
            <rect x="206" y="86" width="28" height="228" fill="#0b0d11" />
          </g>
          <g id="right-ear">
            <rect x="2634" y="90" width="143" height="218" rx="7" fill="url(#handle)" class="stroke" />
            <rect x="2672" y="106" width="96" height="178" rx="5" fill="#20242b" />
            <path d="M2680 110h79M2680 118h78" class="fine" />
            <rect x="2623" y="86" width="28" height="228" fill="#0b0d11" />
            <rect x="2690" y="216" width="48" height="69" rx="3" fill="#1d61b9" />
            <text x="2714" y="246" text-anchor="middle" font-size="18" fill="#fff" class="tiny">intel</text>
            <text x="2714" y="269" text-anchor="middle" font-size="14" fill="#fff" class="tiny">XEON</text>
            <rect x="2688" y="212" width="52" height="78" rx="4" fill="none" stroke="#6a99d8" stroke-width="2" />
          </g>

          <g id="top-panel">
            <rect x="232" y="86" width="2400" height="83" fill="#101216" />
            <rect x="235" y="90" width="385" height="72" fill="#07080a" />
            <text x="274" y="133" font-size="34" fill="#e9edf3" class="label">DELL</text>
            <circle cx="404" cy="124" r="20" fill="#16251a" stroke="#75bd50" stroke-width="4" />
            <path d="M404 109v15" stroke="#8bd86d" stroke-width="5" stroke-linecap="round" />
            <path d="M393 124a12 12 0 1 0 22 0" fill="none" stroke="#8bd86d" stroke-width="4" />
            <circle cx="475" cy="124" r="11" fill="#1b1d22" />
            <rect x="532" y="98" width="96" height="52" rx="8" fill="#20242a" stroke="#7c8590" stroke-width="5" />
            <path d="M548 112h66M548 122h66M548 132h66" class="fine" />
            <rect x="682" y="105" width="120" height="38" rx="3" fill="#242831" />
            <path d="M706 124l-15-12v24Zm44-18l-24 18 24 18m19-36l24 18-24 18" fill="#b4bcc6" />
            <rect x="842" y="94" width="233" height="64" rx="2" fill="url(#screen)" />
            <text x="860" y="119" font-size="24" fill="#cfe2ff" class="tiny">Setup | View</text>
            <text x="843" y="151" font-size="25" fill="#f3f8ff" class="label">{{ modelLabel }}</text>
            <rect x="1086" y="102" width="82" height="42" rx="4" fill="#0a0b0d" stroke="#606873" stroke-width="3" />
            <rect x="1190" y="102" width="82" height="42" rx="4" fill="#0a0b0d" stroke="#606873" stroke-width="3" />
            <path d="M1098 114h56M1202 114h56M1105 131h42M1208 131h42" class="fine" />
            <rect x="1317" y="88" width="505" height="76" fill="url(#topSlots)" />
            <rect x="1384" y="126" width="117" height="18" rx="2" fill="#b8c5cf" />
            <text x="1443" y="141" text-anchor="middle" font-size="16" fill="#58616b" class="tiny">SSD</text>
            <text x="1438" y="163" text-anchor="middle" font-size="18" fill="#c5cbd3" class="tiny">1</text>
            <rect x="1829" y="90" width="724" height="72" rx="4" fill="#202229" stroke="#41464f" stroke-width="3" />
            <text x="1905" y="127" font-size="23" fill="#9da4ad" class="tiny">DISC</text>
            <rect x="2000" y="110" width="36" height="25" rx="4" fill="#575d66" />
            <text x="2018" y="130" text-anchor="middle" font-size="15" fill="#111" class="tiny">RW</text>
            <text x="2062" y="126" font-size="20" fill="#c6ccd3" class="tiny">DVD</text>
            <rect x="2265" y="111" width="66" height="25" rx="4" fill="#15171d" />
            <circle cx="2357" cy="125" r="4" fill="#3e444d" />
            <rect x="2553" y="88" width="69" height="76" fill="url(#topSlots)" />
            <text x="2594" y="163" text-anchor="middle" font-size="18" fill="#c5cbd3" class="tiny">3</text>
          </g>

          <g transform="translate(232,0) scale(0.965,1) translate(-232,0)">
          <rect x="230" y="169" width="2395" height="142" fill="#0b0d11" />
          <rect x="238" y="177" width="2378" height="126" rx="5" fill="#171a20" stroke="#050609" stroke-width="5" />

          <g
            v-for="(bay, i) in bays"
            :key="bay.label"
            :transform="`translate(${bayXOffsets[i]} 178) scale(1 .75)`"
            @click="bay.disk && (currentDisk = bay.disk['bay-id'])"
            :class="bay.disk ? 'cursor-pointer' : ''"
          >
            <path :d="bayPath" :fill="bay.disk ? 'url(#bay)' : '#14161a'" class="stroke" />

            <template v-if="bay.disk">
              <rect x="44" y="23" width="79" height="122" rx="7" fill="#191c21" />
              <circle cx="83" cy="84" r="17" fill="#282b31" stroke="#9a653f" stroke-width="5" />
              <rect x="126" y="20" width="334" height="128" rx="14" fill="#9da3ab" />
              <rect x="150" y="36" width="282" height="96" rx="7" fill="#0a0b0e" />
              <rect x="160" y="39" width="262" height="90" fill="url(#mesh)" />
              <use href="#driveGrillBars" />
              <path
                d="M128 22l35-20h278l20 22m-332 126l35 20h280l18-20"
                fill="none"
                stroke="#d3d7dd"
                stroke-width="4"
                opacity=".6"
              />
              <rect x="476" y="53" width="75" height="48" rx="3" fill="#d8dde5" />
              <text x="514" y="82" text-anchor="middle" font-size="18" fill="#555d67" class="tiny">{{ bay.disk.transport || 'SAS' }}</text>
              <rect x="479" y="99" width="72" height="27" rx="3" fill="#101217" />
              <text x="515" y="119" text-anchor="middle" font-size="14" fill="#fff" class="tiny">{{ bay.disk.capacity }}</text>
              <rect x="17" y="53" width="11" height="18" fill="#b7f24e" />
              <rect x="17" y="85" width="11" height="18" :fill="bay.disk.health === 'FAILED' ? '#ff4d4d' : '#3a3f47'" />
            </template>

            <path
              v-if="bay.disk && bay.disk.health === 'FAILED'"
              :d="bayPath"
              fill="none"
              stroke="#ef4444"
              stroke-width="6"
            />
            <path
              v-if="isSelected(bay)"
              :d="bayPath"
              fill="none"
              stroke="#3b82f6"
              stroke-width="6"
            />
            <rect v-if="!bay.disk" x="0" y="0" width="609" height="172" fill="none" stroke="#4a5059" stroke-width="4" stroke-dasharray="10 8" />
          </g>

          <text
            v-for="(bay, i) in bays"
            :key="`label-${bay.label}`"
            :x="bayXOffsets[i] + 305"
            y="345"
            text-anchor="middle"
            fill="#c9ced5"
            style="font-size: 26px"
          >{{ bay.label }}{{ bay.disk && bay.disk.health === 'FAILED' ? ' — FAILED' : '' }}{{ !bay.disk ? ' — empty' : '' }}</text>

          <path d="M230 169h2395M230 310h2395" stroke="#07080a" stroke-width="5" opacity=".9" />
          </g>
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
const BAY_X_OFFSETS = [232, 852, 1470, 2087];
const BAY_PATH = "M0 0h586l23 24v123l-23 25H0Z";

export default {
  components: {
    RefreshIconOutline,
  },
  props: {
    rows: {
      type: Array,
      default: () => [],
    },
    serverInfo: {
      type: Object,
      default: () => ({}),
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

    const isSelected = (bay) => !!bay.disk && currentDisk.value === bay.disk["bay-id"];

    const modelLabel = computed(() => props.serverInfo?.Model || "PowerEdge R330");

    return {
      currentDisk,
      bays,
      bayXOffsets: BAY_X_OFFSETS,
      bayPath: BAY_PATH,
      isSelected,
      modelLabel,
    };
  },
};
</script>
