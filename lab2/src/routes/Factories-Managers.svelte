<script lang="ts">
    import {
        DataTable,
        Toolbar,
        ToolbarContent,
        ToolbarBatchActions,
        Button,
        ToolbarSearch,
        Pagination,
        Modal,
    } from "carbon-components-svelte"
    import TrashCan from "carbon-icons-svelte/lib/TrashCan.svelte"
    import Edit from "carbon-icons-svelte/lib/Edit.svelte"
    import ManagerForm from "../lib/ManagerForm.svelte"
    import FactoryForm from "../lib/FactoryForm.svelte"
    import { add_manager_factory, edit_factory, edit_manager, factories, list_factories, list_managers, managers } from "../lib/api"
    import { onMount } from 'svelte'

    var rows = []

    onMount(async () => {
        $managers = await list_managers()
        $factories = await list_factories()
        console.log($managers)
    })

    $: {
        console.log($factories)
        rows = $factories.map(factory => {
            let manager = $managers.find(m => m.id == factory.manager_id)
            return {
                id: factory.id,
                factory_name: factory.name,
                factory_location: factory.location,
                factory_floor_size: factory.floor_size,
                manager_fullname: `${manager.first_name} ${manager.surname}`
            }
        })
    }

    let isModalShown = false
    let resetFactoryForm, validateFactoryForm, factoryData
    let resetManagerForm, validateManagerForm, managerData

    let activeDelete = false
    let selectedRowIds = []
    let filteredRowIds = []

    let currentlyEditingId = undefined
    let showUpdateModal = factory_id => {
        currentlyEditingId = factory_id

        let factory = $factories.find(factory => factory.id == factory_id)
        let manager = $managers.find(manager => manager.id == factory.manager_id)

        factoryData.name = factory.name
        factoryData.location = factory.location
        factoryData.floor_size = factory.floor_size
        managerData.first_name = manager.first_name
		managerData.surname = manager.surname
		managerData.phone_number = manager.phone_number
		managerData.title = manager.title
		managerData.email = manager.email

        isModalShown = true
    }

    let showCreateModal = () => {
        currentlyEditingId = undefined
        resetFactoryForm()
        resetManagerForm()
        isModalShown = true
    }

    let closeModal = () => {
        isModalShown = false
    }
</script>

<DataTable
    zebra
    selectable={activeDelete}
    batchSelection={activeDelete}
    sortable
    bind:selectedRowIds
    headers={[
        { key: "factory_name", value: "Factory" },
        { key: "factory_location", value: "Location" },
        { key: "factory_floor_size", value: "Floor size" },
        { key: "manager_fullname", value: "Manager" },
        { key: "update_btn", empty: true, width: "5rem" },
    ]}
    {rows}
>
    <Toolbar>
    <ToolbarBatchActions
        bind:active={activeDelete}
        on:cancel={(e) => {
            e.preventDefault();
            activeDelete = false;
        }}
    >
        <Button
            icon={TrashCan}
            disabled={selectedRowIds.length === 0}
            on:click={() => {
                rows = rows.filter((row) => !selectedRowIds.includes(row.id));
                selectedRowIds = [];
            }}
        >
            Delete
        </Button>
    </ToolbarBatchActions>
    <ToolbarContent>
        <ToolbarSearch
            persistent
            shouldFilterRows
            bind:filteredRowIds
        />
        <Button on:click={showCreateModal}>Create</Button>
        <Button on:click={() => activeDelete = true}>Delete</Button>
    </ToolbarContent>
    </Toolbar>
    <svelte:fragment slot="cell" let:row let:cell>
        {#if cell.key === "update_btn"}
            <Button
                kind="ghost"
                size="field"
                iconDescription={"Edit"}
                icon={Edit}
                on:click={() => showUpdateModal(row.id)}
                />
        {:else}
            {cell.value}
        {/if}
    </svelte:fragment>
</DataTable>

<Modal
    bind:open={isModalShown}
    modalHeading={currentlyEditingId ? "Edit factory & manager" : "Create factory & manager"}
    primaryButtonText="Confirm"
    secondaryButtonText="Cancel"
    on:open
    on:click:button--secondary={closeModal}
    on:submit={async () => {
        let isFactoryValid = validateFactoryForm()
        let isManagerValid = validateManagerForm()
        if (!(isFactoryValid && isManagerValid)) {
            return false
        }

        if (currentlyEditingId) {
            // TODO: Handle if factory is not found
            let manager_id = $factories.find(factory => factory.id == currentlyEditingId).manager_id

            await edit_factory(currentlyEditingId, factoryData) // TODO: handle if failed
            await edit_manager(manager_id, managerData) // TODO: handle if failed
        } else {
            await add_manager_factory(factoryData, managerData) // TODO: handle error
        }

        closeModal()
        return true
    }}
>
    <div class="flex flex-row gap-1rem">
        <div class="flex-grow">
            <p>Factory</p>
            <FactoryForm
                bind:factory={factoryData}
                bind:validate={validateFactoryForm}
                bind:reset={resetFactoryForm}
            />
        </div>
        <div class="flex-grow-2">
            <p>Manager</p>
            <ManagerForm
                bind:manager={managerData}
                bind:validate={validateManagerForm}
                bind:reset={resetManagerForm}
            />
        </div>
    </div>
</Modal>