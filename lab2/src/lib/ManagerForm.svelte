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

	// Phone number validation
	let showPhoneNumberInvalid = false
	function validatePhoneNumber() {
		showPhoneNumberInvalid = false
		if (manager.phone_number === "") {
			return
		}

		let allowedSymbols = " +()1234567890"
		for (var symbol of manager.phone_number) {
			console.log(symbol)
			if (allowedSymbols.indexOf(symbol) == -1) {
				showPhoneNumberInvalid = true
				return
			}
		}
	}

	// Email validation
	let showEmailInvalid = false
	function validateEmail() {
		if (manager.email === "") {
			showEmailInvalid = false
			return
		}

		showEmailInvalid = !manager.email.includes("@")
	}

	// Exports
	export const validate = () => {
		validateFirstName()
		validateSurname()
		validateTitle()
		validateEmail()
		validatePhoneNumber()
		return !showFirstNameInvalid && !showSurnameInvalid && !showTitleInvalid && !showEmailInvalid && !showPhoneNumberInvalid
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
		showEmailInvalid = false
		showPhoneNumberInvalid = false
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
		bind:invalid={showPhoneNumberInvalid}
		on:input={validatePhoneNumber}
		invalidText={"Phone number can only contain '+', ' ', '(', ')' and numbers"}
		labelText="Phone number"
	/>
	<TextInput
		bind:value={manager.email}
		bind:invalid={showEmailInvalid}
		on:input={validateEmail}
		invalidText={"Email must contain '@'"}
		labelText="Email"
	/>
</Form>
