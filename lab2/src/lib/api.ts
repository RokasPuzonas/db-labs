import { invoke } from '@tauri-apps/api/tauri'
import { get, writable, type Writable } from 'svelte/store'

export type Id = number

export interface ManagerData {
	first_name: string,
	surname: string,
	phone_number?: string,
	title: string,
	email?: string
}
export interface Manager extends ManagerData {
	id: Id
}

export interface FactoryData {
	name: string,
	location: string,
	floor_size: number
}
export interface Factory extends FactoryData {
	id: Id,
	manager_id: Id
}

export interface ProcessData {
    name: string,
    size: number
}
export interface Process extends ProcessData {
    id: Id
}

export let factory_processess = writable<Record<Id, Id[]>>([])
export let factories          = writable<Factory[]>([])
export let managers           = writable<Manager[]>([])
export let processess         = writable<Process[]>([])

function add_object<T>(objects: Writable<T[]>, object: T) {
    objects.update((objects) => {
        objects.push(object)
        return objects
    })
}

function update_object<T>(objects: Writable<T[]>, index: number, updates: Partial<T>) {
    if (index == -1) return

    objects.update((objects) => {
        const obj = objects[index]
        for (var key in updates) {
            obj[key] = updates[key]
        }
        return objects
    })
}

function remove_object<T>(objects: Writable<T[]>, index: number) {
    if (index == -1) return

    objects.update((objects) => {
        objects.splice(index, 1)
        return objects
    })
}

function remove_manager_by_id(id: number) {
    remove_object(managers, get(managers).findIndex(m => m.id == id))
}

export async function list_factories(): Promise<Factory[]> {
    return invoke("list_factories")
}

export async function list_managers(): Promise<Manager[]> {
    return invoke("list_managers")
}

export async function list_processess(): Promise<Process[]> {
    return invoke("list_processess")
}

export async function list_factory_processess(id: number): Promise<Id[]> {
    return invoke("list_factory_processess", { id })
}

// Result -> Promise<[factory_id, manager_id]>
export async function add_manager_factory(factory: FactoryData, manager: ManagerData): Promise<[number, number]> {
    // TODO: For now always assume success
    // TODO: handle error
    let [factory_id, manager_id] = await invoke<[number, number]>("add_manager_factory", { factory, manager })

    add_object<Factory>(factories, {
        id: factory_id,
        manager_id,
        ...factory
    })
    add_object<Manager>(managers, {
        id: manager_id,
        ...manager
    })

    return [factory_id, manager_id]
}

export async function update_manager(id: number, manager: ManagerData): Promise<void> {
    await invoke("update_manager", { id, manager })

    const index = get(managers).findIndex(f => f.id == id)
    update_object(managers, index, manager)
}

export async function update_factory(id: number, factory: FactoryData): Promise<void> {
    await invoke("update_factory", { id, factory })

    const index = get(factories).findIndex(f => f.id == id)
    update_object(factories, index, factory)
}

export async function delete_factory(id: number): Promise<void> {
    await invoke("delete_factory", { id })

    const index = get(factories).findIndex(f => f.id == id)
    if (index != -1) {
        var manager_id = factories[index]
        remove_object(factories, index)
        remove_manager_by_id(manager_id)
    }
}

export async function delete_process(id: number): Promise<void> {
    await invoke("delete_process", { id })

    const index = get(processess).findIndex(f => f.id == id)
    remove_object(processess, index)
}

export async function add_process(process: ProcessData): Promise<number> {
    // TODO: For now always assume success
    // TODO: handle error
    let id = await invoke<number>("add_process", { process })

    add_object<Process>(processess, {
        id,
        ...process
    })

    return id
}

export async function update_process(id: number, process: ProcessData): Promise<void> {
    await invoke("update_process", { id, process })

    var index = get(processess).findIndex(f => f.id == id)
    update_object(processess, index, process)
}

export async function add_factory_processess(factory_id: Id, process_ids: Id[]): Promise<void> {
    for (var processId of process_ids) {
        await invoke("add_factory_process", { factoryId: factory_id, processId })
    }

    factory_processess.update((factory_processess) => {
        if (factory_processess[factory_id] == undefined) {
            factory_processess[factory_id] = []
        }
        for (var process_id of process_ids) {
            factory_processess[factory_id].push(process_id)
        }
        return factory_processess
    })
}

export async function update_factory_processess(factory_id: Id, process_ids: Id[]): Promise<void> {
    let current = get(factory_processess)[factory_id]

    let added   = process_ids.filter(id => !current.includes(id))
    let removed = current.filter(id => !process_ids.includes(id))

    for (var processId of added) {
        await invoke("add_factory_process", { factoryId: factory_id, processId })
    }

    for (var processId of removed) {
        await invoke("delete_factory_process", { factoryId: factory_id, processId })
    }

    factory_processess.update((factory_processess) => {
        if (factory_processess[factory_id] == undefined) {
            factory_processess[factory_id] = []
        }

        var processess = factory_processess[factory_id]
        for (var process_id of added) {
            processess.push(process_id)
        }
        for (var process_id of removed) {
            processess.splice(processess.findIndex(id => id === process_id), 1)
        }
        return factory_processess
    })
}