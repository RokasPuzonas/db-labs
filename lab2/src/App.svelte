<script lang="ts">
	import Router, {location} from "svelte-spa-router"
	import { Header, Content, SideNav, SideNavItems, SideNavLink } from "carbon-components-svelte";
	import User from "carbon-icons-svelte/lib/User.svelte";

	import Home from './routes/Home.svelte'
	import FactoriesManagers from './routes/Factories-Managers.svelte'

	let isSideNavOpen = false;
</script>

<Header href="/#/" company="ICE" platformName="Production" />
<SideNav bind:isOpen={isSideNavOpen} rail>
	<SideNavItems>
		<SideNavLink
			icon={User}
			text="Factories & Managers"
			href="/#/factories-managers"
			isSelected={$location == "/factories-managers"}
		/>
	</SideNavItems>
</SideNav>

<Content>
	<Router routes={{
		"/": Home,
		"/factories-managers": FactoriesManagers,
	}} />
</Content>
