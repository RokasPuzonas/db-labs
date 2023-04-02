<script lang="ts">
	import { Form, TextInput } from "carbon-components-svelte";
    import type { ManagerData } from "./api";

	export let manager: ManagerData = {
		first_name:   "",
		surname:      "",
		phone_number: "",
		title:        "",
		email:        ""
	}

	// First name validation
	let showFirstNameInvalid = false;
	function validateFirstName() {
		showFirstNameInvalid = manager.first_name === ""
	}

	// Surname validation
	let showSurnameInvalid = false;
	function validateSurname() {
		showSurnameInvalid = manager.surname === ""
	}

	// Title validation
	let showTitleInvalid = false;
	function validateTitle() {
		showTitleInvalid = manager.title === ""
	}

	// Exports
	export const validate = () => {
		validateFirstName()
		validateSurname()
		validateTitle()
		return !showFirstNameInvalid && !showSurnameInvalid && !showTitleInvalid
	};

	export const reset = () => {
		manager.first_name = ""
		manager.surname = ""
		manager.phone_number = ""
		manager.title = ""
		manager.email = ""
		showFirstNameInvalid = false
		showSurnameInvalid = false
		showTitleInvalid = false
	};
</script>


<Form class="flex flex-col gap-1rem" title="Manager">
	<TextInput
		bind:value={manager.first_name}
		invalidText={"First name can't be empty"}
		bind:invalid={showFirstNameInvalid}
		on:input={validateFirstName}
		required
		labelText="First name"
	/>
	<TextInput
		bind:value={manager.surname}
		invalidText={"Surname can't be empty"}
		bind:invalid={showSurnameInvalid}
		on:input={validateSurname}
		required
		labelText="Surname"
	/>
	<TextInput
		bind:value={manager.title}
		invalidText={"Title can't be empty"}
		bind:invalid={showTitleInvalid}
		on:input={validateTitle}
		required
		labelText="Title"
	/>
	<TextInput
		bind:value={manager.phone_number}
		labelText="Phone number"
	/>
	<TextInput
		bind:value={manager.email}
		labelText="Email"
	/>
</Form>
