
export {};


/** @noSelf **/
declare namespace _serverAPI {
    export function on(event: string, callback: (...args: unknown[]) => void): void;
    export function broadcast(event: string, ...args: any[]): void;
    export function unicast(username: string, event: string, ...args: any[]): void;
    export function lazyBroadcast(event: string, ...args: any[]): void;
    export function lazyUnicast(username: string, event: string, ...args: any[]): void;

    export const entities: LuaMap<string, (...args: any[]) => Entity>;
}

declare global {
    const server: (typeof _serverAPI) | undefined;
}
