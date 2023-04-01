
export {};


/** @noSelf **/
declare interface _serverAPI {
    on(player: PlayerObject, event: string, callback: (...args: unknown[]) => void): void;
    broadcast(event: string, ...args: any[]): void;
    unicast(player: PlayerObject, event: string, ...args: any[]): void;
    lazyBroadcast(event: string, ...args: any[]): void;
    lazyUnicast(player: PlayerObject, event: string, ...args: any[]): void;

    readonly entities: LuaMap<string, (...args: any[]) => Entity>;
}

declare global {
    const server: _serverAPI | undefined;
}
