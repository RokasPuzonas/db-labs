<script>
    import {
        DataTable,
        Toolbar,
        ToolbarContent,
        ToolbarBatchActions,
        Button,
        ToolbarSearch,
        Pagination,
        Modal,
    } from "carbon-components-svelte";
    import TrashCan from "carbon-icons-svelte/lib/TrashCan.svelte";
    import Edit from "carbon-icons-svelte/lib/Edit.svelte";
    import ManagerForm from "../lib/ManagerForm.svelte";
    import FactoryForm from "../lib/FactoryForm.svelte";

    let rows = [
        { id: "a", name: "Load Balancer 3", port: 3000, rule: "Round robin" },
        { id: "b", name: "Load Balancer 1", port: 443, rule: "Round robin" },
        { id: "c", name: "Load Balancer 2", port: 80, rule: "DNS delegation" },
        { id: "d", name: "Load Balancer 6", port: 3000, rule: "Round robin" },
        { id: "e", name: "Load Balancer 4", port: 443, rule: "Round robin" },
        { id: "f", name: "Load Balancer 5", port: 80, rule: "DNS delegation" },
    ];

    let activeDelete = false
    let activeUpdate = false
    let selectedRowIds = []
    let filteredRowIds = []

    let resetFactoryForm, validateFactoryForm;
    let resetManagerForm, validateManagerForm;
    let showCreateModal = false;
    $: if (showCreateModal) {
        resetFactoryForm()
        resetManagerForm()
    }

    let headers = [
        { key: "name", value: "Name" },
        { key: "port", value: "Port" },
        { key: "rule", value: "Rule" },
        { key: "update-btn", empty: true, width: "5rem" },
    ]
</script>

<DataTable
    zebra
    selectable={activeDelete}
    batchSelection={activeDelete}
    sortable
    bind:selectedRowIds
    {headers}
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
        <Button on:click={() => showCreateModal = true}>Create</Button>
        <Button on:click={() => (activeDelete = true)}>Delete</Button>
    </ToolbarContent>
    </Toolbar>
    <svelte:fragment slot="cell" let:cell>
        {#if cell.key === "update-btn"}
            <Button kind="ghost" size="field" iconDescription={"Edit"} icon={Edit} />
        {:else}
            {cell.value}
        {/if}
    </svelte:fragment>
</DataTable>

<Modal
    bind:open={showCreateModal}
    modalHeading="Create factory & manager"
    primaryButtonText="Confirm"
    secondaryButtonText="Cancel"
    on:open
    on:close={() => showCreateModal = false}
    on:click:button--secondary={() => showCreateModal = false}
    on:submit={() => {
        let isFactoryValid = validateFactoryForm()
        let isManagerValid = validateManagerForm()
        if (!(isFactoryValid && isManagerValid)) {
            return false
        }

        showCreateModal = false
        return true
    }}
>
    <div class="flex flex-row gap-1rem">
        <div class="flex-grow">
            <p>Factory</p>
            <FactoryForm
                bind:validate={validateFactoryForm}
                bind:reset={resetFactoryForm}
            />
        </div>
        <div class="flex-grow-2">
            <p>Manager</p>
            <ManagerForm
                bind:validate={validateManagerForm}
                bind:reset={resetManagerForm}
            />
        </div>
    </div>
</Modal>