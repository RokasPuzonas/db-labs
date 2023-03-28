<script lang="ts">
	import { Form, TextInput } from "carbon-components-svelte";

	export let manager = {
		firstName:   "",
		surname:     "",
		phoneNumber: "",
		title:       "",
		email:       ""
	}

	// First name validation
	let showFirstNameInvalid = false;
	function validateFirstName() {
		showFirstNameInvalid = manager.firstName === ""
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
		manager.firstName = ""
		manager.surname = ""
		manager.phoneNumber = ""
		manager.title = ""
		manager.email = ""
		showFirstNameInvalid = false
		showSurnameInvalid = false
		showTitleInvalid = false
	};
</script>


<Form class="flex flex-col gap-1rem" title="Manager">
	<TextInput
		bind:value={manager.firstName}
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
		bind:value={manager.phoneNumber}
		labelText="Phone number"
	/>
	<TextInput
		bind:value={manager.email}
		labelText="Email"
	/>
</Form>
