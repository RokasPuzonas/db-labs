<script lang="ts">
    import ManagerForm from "../lib/ManagerForm.svelte"
    import FactoryForm from "../lib/FactoryForm.svelte"
    import { add_manager_factory, delete_factory, update_factory, update_manager, factories, managers, factory_processess, add_factory_processess, update_factory_processess } from "../lib/api"
    import ProcessList from "../lib/ProcessList.svelte"
    import MyDataTable from "../lib/MyDataTable.svelte"

    var rows = []

    $: {
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

    let processess = []
    let resetProcessList, prepareProcessess
    let resetFactoryForm, validateFactoryForm, factoryData
    let resetManagerForm, validateManagerForm, managerData

    let showUpdateModal = event => {
        let factory_id = event.detail
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

        if ($factory_processess[factory_id]) {
            prepareProcessess([ ...$factory_processess[factory_id] ])
        } else {
            prepareProcessess([])
        }
    }

    let showAddModal = () => {
        resetFactoryForm()
        resetManagerForm()
        resetProcessList()
    }

    let validateModal = (event) => {
        let isFactoryValid = validateFactoryForm()
        let isManagerValid = validateManagerForm()
        let valid = isFactoryValid && isManagerValid
        if (!valid) {
            event.preventDefault()
        }
    }
</script>

<MyDataTable
    addModalTitle={"Create factory & manager"}
    updateModalTitle={"Edit factory & manager"}
    bind:rows
    on:showAddModal={showAddModal}
    on:showUpdateModal={showUpdateModal}
    on:validateModal={validateModal}
    on:add={async () => {
        let [factory_id, _] = await add_manager_factory(factoryData, managerData)
        await add_factory_processess(factory_id, processess)
    }}
    on:update={async (event) => {
        let factory_id = event.detail
        let manager_id = $factories.find(factory => factory.id == factory_id).manager_id
        await update_factory(factory_id, factoryData)
        await update_manager(manager_id, managerData)
        await update_factory_processess(factory_id, processess)
    }}
    on:delete={async (event) => {
        let ids = event.detail
        for (var id of ids) {
            await delete_factory(id)
        }
    }}
    headers={[
        { key: "factory_name", value: "Factory" },
        { key: "factory_location", value: "Location" },
        { key: "factory_floor_size", value: "Floor size" },
        { key: "manager_fullname", value: "Manager" }
    ]}
>
    <div class="flex flex-row gap-1rem mb-1rem">
        <div class="flex-grow w-50">
            <p>Factory</p>
            <FactoryForm
                bind:factory={factoryData}
                bind:validate={validateFactoryForm}
                bind:reset={resetFactoryForm}
            />
        </div>
        <div class="flex-grow w-50">
            <p>Manager</p>
            <ManagerForm
                bind:manager={managerData}
                bind:validate={validateManagerForm}
                bind:reset={resetManagerForm}
            />
        </div>
    </div>

    <div class="mt-1rem">
        <p class="mb-0.5rem">Processess</p>
        <ProcessList
            bind:processess
            bind:prepare={prepareProcessess}
            bind:reset={resetProcessList}
        />
    </div>
</MyDataTable>
