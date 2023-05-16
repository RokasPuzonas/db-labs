<script lang="ts">
	import { Form, TextInput, NumberInput } from "carbon-components-svelte";
	import type { FactoryData } from "./api"

	export let factory: FactoryData = {
		name:      "",
		location:  "",
		floor_size: 1
	}

	// Name validation
	let showNameInvalid = false;
	function validateName() {
		showNameInvalid = factory.name === ""
	}

	// Location validation
	let showLocationInvalid = false;
	function validateLocation() {
		showLocationInvalid = factory.location === ""
	}

	// Exports
	export const validate = () => {
		validateName()
		validateLocation()
		return !showLocationInvalid && !showNameInvalid && factory.floor_size >= 1
	};

	export const reset = () => {
		factory.name = ""
		factory.location = ""
		factory.floor_size = 1
		showNameInvalid = false
		showLocationInvalid = false
	};
</script>

<Form class="flex flex-col gap-1rem" title="Factory">
	<TextInput
		bind:value={factory.name}
		invalidText={"Name can't be empty"}
		bind:invalid={showNameInvalid}
		on:input={validateName}
		required
		labelText="Name"
	/>
	<TextInput
		bind:value={factory.location}
		invalidText={"Location can't be empty"}
		bind:invalid={showLocationInvalid}
		on:input={validateLocation}
		required
		labelText="Location"
	/>
	<NumberInput
        bind:value={factory.floor_size}
        required
		hideSteppers
        min={1}
        invalidText="Floor size must be at least 1m²"
        label="Floor size (m²)"
    />
</Form>
