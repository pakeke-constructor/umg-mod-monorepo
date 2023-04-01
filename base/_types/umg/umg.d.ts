
export {};



// Math overrides provided by UMG:
/** @NoSelf **/
declare module "math" {
    function normalize(x: number, y: number, z: number|undefined): LuaMultiReturn<[number, number, number|undefined]>
    function distance(x: number, y: number, z: number|undefined): number;
    function clamp(x: number, lower: number, upper: number): number;
    function round(x: number): number;
}


declare global {

    /** @noSelf **/
    export namespace umg {
        export function on(event: string, callback: (...args: unknown[]) => void): void;
        export function call(event: string, ...args: unknown[]): void;

        export function extend(parentEntityName: string, definition: LuaTable<String, unknown>): any;

        export function group<T>(...args: (keyof T)[]): Group<T>;

        export function exists(ent: unknown): ent is Entity;

        export function save(fname: string, data: string): void;
        export function load(fname: string): string;

        export function expose(name: string, value: unknown): void;
        
        export function serialize(data: unknown): string;
        export function deserialize(data: string): LuaMultiReturn<[unknown|null, string?]>;

        export function register(resource: unknown, alias: string): void;
    }

    export interface Entity {
        readonly id: number;
        isRegular(componentName: string): boolean;
        isShared(componentName: string): boolean;
        hasComponent<T>(componentName: keyof T): this is T;
        type(): string;
    }
    
    export interface Group<T>{
        (this: Group<T>): LuaIterable<Entity & T>;
        // iteration, i.e. for [k,v] in group() {  }
        size(): number;
        has(ent: Entity): boolean;
        onAdded(callback: (entity: Entity & T) => void): void;
        onRemoved(callback: (entity: Entity & T) => void): void;
        deleteCallback(callback: (entity: Entity & T) => void): void;
    }
}

