<script lang="ts">
	import Router, {location} from "svelte-spa-router"
	import { Header, Content, SideNav, SideNavItems, SideNavLink } from "carbon-components-svelte";
    import { factories, factory_processess, list_factories, list_factory_processess, list_managers, list_processess, managers, processess } from "./lib/api";
    import { onMount } from "svelte";
    import { Building, Calibrate, ReportData } from "carbon-icons-svelte";

	import Home from './routes/Home.svelte'
	import FactoriesManagers from './routes/Factories-Managers.svelte'
    import Processess from "./routes/Processess.svelte";
    import Report from "./routes/Report.svelte";

	onMount(async () => {
        $managers = await list_managers()
        $factories = await list_factories()
		$processess = await list_processess()
		for (var factory of $factories) {
			$factory_processess[factory.id] = await list_factory_processess(factory.id)
		}
    })

	let isSideNavOpen = false;
</script>

<Header href="/#/" company="ICE" platformName="Production" bind:isSideNavOpen />
<SideNav bind:isOpen={isSideNavOpen} rail>
	<SideNavItems>
		<SideNavLink
			icon={ReportData}
			text="Report"
			href="/#/report"
			isSelected={$location == "/report"}
		/>
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
		"/processess": Processess,
		"/report": Report
	}} />
</Content>
