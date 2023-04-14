import { invoke } from '@tauri-apps/api/tauri'
import { writable } from 'svelte/store'

export interface Manager {
	id: number,
	first_name: string,
	surname: string,
	phone_number?: string,
	title: string,
	email?: string
}
export interface ManagerData {
	first_name: string,
	surname: string,
	phone_number?: string,
	title: string,
	email?: string
}

export interface Factory {
	id: number,
	name: string,
	location: string,
	floor_size: number,
	manager_id: number
}
export interface FactoryData {
	name: string,
	location: string,
	floor_size: number
}

export let factories = writable<Factory[]>([])
export let managers  = writable<Manager[]>([])

function remove_manager_by_id(id: number) {
    managers.update(managers => {
        var index = managers.findIndex(m => m.id == id)
        if (index != -1) {
            managers.splice(index, 1)
        }
        return managers
    })
}

export async function list_factories(): Promise<Factory[]> {
    return invoke("list_factories")
}

export async function list_managers(): Promise<Manager[]> {
    return invoke("list_managers")
}

// Result -> Promise<[factory_id, manager_id]>
export async function add_manager_factory(factory: FactoryData, manager: ManagerData): Promise<[number, number]> {
    // TODO: For now always assume success
    // TODO: handle error
    let [factory_id, manager_id] = await invoke<[number, number]>("add_manager_factory", { factory, manager })

    factories.update((factories) => {
        factories.push({
            id: factory_id,
            manager_id,
            ...factory
        })
        return factories
    })
    managers.update((managers) => {
        managers.push({ id: manager_id, ...manager })
        return managers
    })

    return [factory_id, manager_id]
}

export async function update_manager(id: number, manager: ManagerData): Promise<void> {
    invoke("update_manager", { id, manager })

    managers.update((managers) => {
        var index = managers.findIndex(f => f.id == id)
        if (index != -1) {
            managers[index] = {
                ...managers[index],
                ...manager
            }
        }
        return managers
    })
}

export async function update_factory(id: number, factory: FactoryData): Promise<void> {
    invoke("update_factory", { id, factory })

    factories.update((factories) => {
        var index = factories.findIndex(f => f.id == id)
        if (index != -1) {
            factories[index] = {
                ...factories[index],
                ...factory
            }
        }
        return factories
    })
}

export async function delete_factory(id: number): Promise<void> {
    invoke("delete_factory", { id })

    factories.update((factories) => {
        var index = factories.findIndex(f => f.id == id)
        if (index != -1) {
            remove_manager_by_id(factories[index].manager_id)
            factories.splice(index, 1)
        }
        return factories
    })
}