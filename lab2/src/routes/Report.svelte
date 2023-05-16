<script lang="ts">
    import { Button, DataTable, NumberInput, TextInput } from "carbon-components-svelte";
    import { factories, processess, get_factories_by_used_space, get_processess_of_factory, type ProcessData } from "../lib/api";
    import { writable } from "svelte/store";

    let from_bound = 50.00
    let to_bound = 100.00
    let location = "Kaunas"

    let rows = writable([])

    async function requestReport() {
        let newRows = []

        const results = await get_factories_by_used_space(from_bound, to_bound, location)
        for (var result of results) {
            var factory = $factories.find(factory => factory.id == result.factory_id)
            if (factory === undefined) continue
            const processess = await get_processess_of_factory(result.factory_id) as (ProcessData & { id: string })[]
            for (const process of processess) {
                process.id = process.name
            }

            newRows.push({
                id: result.factory_id,
                manager_name: result.manager_name,
                factory_name: factory.name,
                factory_size: factory.floor_size,
                used_percent: `${result.used_percent}%`,
                used_size: result.used_size,
                processess
            })
        }
        $rows = newRows
    }
</script>

<div class="flex flex-row gap-1rem mb-1rem">
    <NumberInput
        bind:value={from_bound}
        required
        hideSteppers
        min={0}
        invalidText="Can't be negative"
        label="Lower used size bound (%)"
    />
    <NumberInput
        bind:value={to_bound}
        required
        hideSteppers
        min={0}
        invalidText="Can't be negative"
        label="Upper used size bound (%)"
    />
    <TextInput
        bind:value={location}
        required
        invalidText="Location can't be empty"
        labelText="Location"
    />
    <div class="pt">
        <Button on:click={requestReport}>
            Go
        </Button>
    </div>
</div>

<DataTable
    expandable
    zebra
    rows={$rows}
    headers={[
        { key: "manager_name", value: "Manager" },
        { key: "factory_name", value: "Factory name" },
        { key: "factory_size", value: "Factory size"},
        { key: "used_size", value: "Used size" },
        { key: "used_percent", value: "Used percent" }
    ]}
>
    <svelte:fragment slot="expanded-row" let:row>
        <DataTable
            size="compact"
            rows={row.processess}
            headers={[
                { key: "name", value: "Process Name" },
                { key: "size", value: "Process Size" }
            ]}
        >
        </DataTable>
    </svelte:fragment>
</DataTable>