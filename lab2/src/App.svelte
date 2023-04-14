<script lang="ts">
	import Router, {location} from "svelte-spa-router"
	import { Header, Content, SideNav, SideNavItems, SideNavLink } from "carbon-components-svelte";
	import Home from './routes/Home.svelte'
	import FactoriesManagers from './routes/Factories-Managers.svelte'
    import { factories, list_factories, list_managers, list_processess, managers, processess } from "./lib/api";
    import { onMount } from "svelte";
    import Processess from "./routes/Processess.svelte";
    import { Building, Calibrate } from "carbon-icons-svelte";

	onMount(async () => {
        $managers = await list_managers()
        $factories = await list_factories()
		$processess = await list_processess()
    })

	let isSideNavOpen = false;
</script>

<Header href="/#/" company="ICE" platformName="Production" bind:isSideNavOpen />
<SideNav bind:isOpen={isSideNavOpen} rail>
	<SideNavItems>
		<SideNavLink
			icon={Building}
			text="Factories & Managers"
			href="/#/factories-managers"
			isSelected={$location == "/factories-managers"}
		/>
		<SideNavLink
			icon={Calibrate}
			text="Processess"
			href="/#/processess"
			isSelected={$location == "/processess"}
		/>
	</SideNavItems>
</SideNav>

<Content>
	<Router routes={{
		"/": Home,
		"/factories-managers": FactoriesManagers,
		"/processess": Processess
	}} />
</Content>
