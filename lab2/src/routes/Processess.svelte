<script lang="ts">
    import { add_process, delete_process, processess, update_process } from "../lib/api";
    import MyDataTable from "../lib/MyDataTable.svelte";
    import ProcessForm from "../lib/ProcessForm.svelte";

    let resetProcessForm, validateProcessForm, processData
</script>

<MyDataTable
    addModalTitle={"Create process"}
    updateModalTitle={"Edit process"}
    rows={$processess}
    on:delete={async (event) => {
        let ids = event.detail
        for (var id of ids) {
            await delete_process(id)
        }
    }}
    on:showAddModal={resetProcessForm}
    on:showUpdateModal={(event) => {
        let id = event.detail
        let process = $processess.find(process => process.id == id)
        processData.name = process.name
        processData.size = process.size
    }}
    on:validateModal={(event) => {
        if (!validateProcessForm()) event.preventDefault()
    }}
    on:add={async () => {
        await add_process(processData)
    }}
    on:update={async (event) => {
        let id = event.detail
        await update_process(id, processData)
    }}
    headers={[
        { key: "name", value: "Name" },
        { key: "size", value: "Size" }
    ]}
>
    <ProcessForm
        bind:process={processData}
        bind:validate={validateProcessForm}
        bind:reset={resetProcessForm}
    />
</MyDataTable>