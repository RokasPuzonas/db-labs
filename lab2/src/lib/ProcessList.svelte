<script lang="ts">
    import { Button, Dropdown } from "carbon-components-svelte"
    import { AddAlt, TrashCan } from "carbon-icons-svelte"
    import { processess as allProcessess, type Id } from "./api"

    export let processess: Id[] = []

    let allProcessItems = []
    let selectedAdd = undefined

    function getAvailableProcessess() {
        return allProcessItems
            .filter(item => !processess.includes(item.id))
            .map(item => item.id)
    }

    $: allProcessItems = $allProcessess.map(process => ({ id: process.id, text: process.name }))

    $: {
        let available = getAvailableProcessess()
        if (!available.includes(selectedAdd) && available.length > 0) {
            selectedAdd = available[0]
        }
    }

    function addRow(newId) {
        processess = [ ...processess, newId ]
        selectedAdd = getAvailableProcessess()[0]
    }

    export function reset() {
        selectedAdd = undefined
        processess = []
	}

    export function prepare(newProcessess) {
        processess = newProcessess
        selectedAdd = getAvailableProcessess()[0]
    }
</script>

<div>
    <div class="flex flex-col gap-1rem">
        {#each processess as id}
            <div class="flex flex-row gap-1rem">
                <Dropdown
                    class="flex-grow"
                    bind:selectedId={id}
                    items={allProcessItems.filter(item => item.id == id || !processess.includes(item.id))}
                />
                <Button
                    icon={TrashCan}
                    iconDescription="Delete"
                    kind="danger-tertiary"
                    on:click={() => {
                        processess = processess.filter(row => row != id)
                    }}
                />
            </div>
        {/each}


        <div class="flex flex-row gap-1rem">
            {#if allProcessItems.length === processess.length}
                <Dropdown
                    class="flex-grow"
                    selectedId={1}
                    items={[{ id: 1, text: "No process available" }]}
                    disabled={true}
                />
                <Button icon={AddAlt} iconDescription="Add" disabled={true} />
            {:else}
                <Dropdown
                    class="flex-grow"
                    bind:selectedId={selectedAdd}
                    items={allProcessItems.filter(item => !processess.includes(item.id))}
                />
                <Button
                    icon={AddAlt}
                    iconDescription="Add"
                    on:click={() => addRow(selectedAdd)}
                />
            {/if}
        </div>
    </div>
</div>