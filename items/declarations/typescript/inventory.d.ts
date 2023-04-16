

interface Inventory {
    (options: {
        width: number,
        height: number,
        slotSize?: number,
        slotSeparation?: number,
        borderWidth?: number,
        autohold?: boolean,
        autoopen?: boolean
    }): Inventory;

    slotExists(x: number, y: number): boolean;
    getIndex(x: number, y: number): number;
    getXY(index: number): LuaMultiReturn<[number, number]>;
}