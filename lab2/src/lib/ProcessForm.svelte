
<script lang="ts">
	import { Form, TextInput, NumberInput } from "carbon-components-svelte";
	import type { ProcessData } from "./api"

	export let process: ProcessData = {
		name: "",
		size: 1
	}

	// Name validation
	let showNameInvalid = false;
	function validateName() {
		showNameInvalid = process.name === ""
	}

	// Exports
	export const validate = () => {
		validateName()
		return !showNameInvalid && process.size >= 1
	};

	export const reset = () => {
		process.name = ""
		process.size = 1
		showNameInvalid = false
	};
</script>

<Form class="flex flex-col gap-1rem" title="Process">
	<TextInput
		bind:value={process.name}
		invalidText={"Name can't be empty"}
		bind:invalid={showNameInvalid}
		on:input={validateName}
		required
		labelText="Name"
	/>
	<NumberInput
        bind:value={process.size}
        required
		hideSteppers
        min={1}
        invalidText="Size must be at least 1m²"
        label="Size (m²)"
    />
</Form>
