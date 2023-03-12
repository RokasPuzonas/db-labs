<script lang="ts">
	import {
		Form,
		Button,
		TextInput
	} from "carbon-components-svelte";
	import { invoke } from '@tauri-apps/api/tauri';

	let firstName = ""
	let surname = ""
	let phoneNumber = ""
	let title = ""
	let email = ""

	let onSubmit = async (e) => {
		e.preventDefault()

		const result = await invoke('add_manager', {
			firstName, surname, phoneNumber, title, email
    })
		console.log("submit")
		console.log(result)
	}
</script>

<Form on:submit={onSubmit} class="flex flex-col gap-1rem">
	<TextInput bind:value={firstName} required labelText="First name" />
	<TextInput bind:value={surname} required labelText="Surname" />
	<TextInput bind:value={phoneNumber} labelText="Phone number" />
	<TextInput bind:value={title} required labelText="Title" />
	<TextInput bind:value={email} labelText="Email" />

	<Button type="submit">Submit</Button>
</Form>
