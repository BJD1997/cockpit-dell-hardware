<template>
	<div class="p-5 flex items-center bg-plugin-header font-redhat shadow-lg z-10">
		<div class="flex flex-row items-baseline basis-32 grow shrink-0">
			<h1 class="text-2xl font-bold text-default">Dell Hardware</h1>
		</div>
		<h1
			class="text-default text-2xl cursor-pointer grow-0 text-center"
			@click="home"
		>{{ moduleName }}</h1>
		<div class="flex basis-32 justify-end grow shrink-0">
			<button
				@click="darkMode = !darkMode"
				id="theme-toggle"
				type="button"
				class="text-muted focus:outline-none"
			>
				<SunIcon v-if="darkMode" class="size-icon-lg" />
				<MoonIcon v-else class="size-icon-lg" />
			</button>
		</div>
	</div>
</template>

<script>
import "@fontsource/red-hat-text/700.css";
import "@fontsource/red-hat-text/400.css";
import { SunIcon, MoonIcon } from "@heroicons/vue/solid";
import { ref, watch } from "vue";

export default {
	props: {
		moduleName: String,
		darkModeInjectionKey: { type: Symbol, required: false, default: null }
	},
	setup(props) {
		const darkMode = props.darkModeInjectionKey ?? ref(true);
		function getTheme() {
			let prefersDark = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
			let theme = localStorage.getItem("color-theme");
			if (theme === null)
				return prefersDark;
			if (theme === "dark")
				return true;
			return false;
		}
		darkMode.value = getTheme();
		if (darkMode.value) {
			document.documentElement.classList.add("dark");
		} else {
			document.documentElement.classList.remove("dark");
		}
		const home = () => {
			cockpit.location.go('/');
		};
		watch(() => darkMode.value, (darkMode, oldDarkMode) => {
			localStorage.setItem("color-theme", darkMode ? "dark" : "light");
			if (darkMode) {
				document.documentElement.classList.add("dark");
			} else {
				document.documentElement.classList.remove("dark");
			}
		}, { lazy: false });
		return {
			darkMode,
			home,
		};
	},
	components: {
		SunIcon,
		MoonIcon
	}
};
</script>
