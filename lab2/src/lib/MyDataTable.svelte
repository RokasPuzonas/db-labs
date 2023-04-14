<script lang="ts">
    import {
        DataTable,
        Toolbar,
        ToolbarContent,
        ToolbarBatchActions,
        Button,
        ToolbarSearch,
        Modal,
    } from "carbon-components-svelte"
    import TrashCan from "carbon-icons-svelte/lib/TrashCan.svelte"
    import Edit from "carbon-icons-svelte/lib/Edit.svelte"
    import { createEventDispatcher } from "svelte"
    import type { DataTableHeader } from "carbon-components-svelte/types/DataTable/DataTable.svelte";

    const dispatch = createEventDispatcher()

    export let addModalTitle = "Create"
    export let updateModalTitle = "Edit"
    export let rows = []
    export let headers: DataTableHeader[] = []

    let isModalShown = false
    let activeDelete = false
    let selectedRowIds = []
    let filteredRowIds = []

    let currentlyUpdatingId = undefined
    export let showUpdateModal = id => {
        currentlyUpdatingId = id
        dispatch("showUpdateModal", id)
        isModalShown = true
    }

    let showAddModal = () => {
        currentlyUpdatingId = undefined
        dispatch("showAddModal")
        isModalShown = true
    }

    let closeModal = () => {
        isModalShown = false
    }

    let deleteSelectedRows = async () => {
        dispatch("delete", selectedRowIds)
        selectedRowIds = []
    }
</script>

<DataTable
    zebra
    selectable={activeDelete}
    batchSelection={activeDelete}
    sortable
    bind:selectedRowIds
    headers={[
        ...headers,
        { key: "update_btn", empty: true, width: "5rem" }
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
            on:click={deleteSelectedRows}
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
        <Button on:click={showAddModal}>Create</Button>
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
    modalHeading={currentlyUpdatingId != undefined ? updateModalTitle : addModalTitle}
    primaryButtonText="Confirm"
    secondaryButtonText="Cancel"
    on:open
    on:click:button--secondary={closeModal}
    on:submit={async () => {
        let valid = dispatch("validateModal", undefined, { cancelable: true })
        if (!valid) {
            return false
        }

        // TODO: Add erro handling
        if (currentlyUpdatingId != undefined) {
            dispatch("update", currentlyUpdatingId)
        } else {
            dispatch("add")
        }

        closeModal()
        return true
    }}
>
    <slot></slot>
</Modal>