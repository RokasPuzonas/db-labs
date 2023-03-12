<script lang="ts">
  import Greet from './lib/Greet.svelte'
	import { Content } from "carbon-components-svelte";

	import Router, {location} from "svelte-spa-router"

	import { Header, HeaderNav, HeaderNavItem } from "carbon-components-svelte";
	import Home from './routes/Home.svelte'
	import Managers from './routes/Managers.svelte'
	import Factories from './routes/Factories.svelte'
</script>

<Header href="/#/" company="ICE" platformName="Management">
	<HeaderNav>
    <HeaderNavItem href="/#/factories" text="Factories" />
    <HeaderNavItem href="/#/managers" text="Managers" />
	</HeaderNav>
</Header>

<Content>
	<Router routes={{
		"/": Home,
		"/managers": Managers,
		"/factories": Factories,
	}} />

	<hr>
	{$location}
</Content>
