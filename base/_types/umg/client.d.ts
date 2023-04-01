

export {};

type Source = import("love.audio").Source;
type Quad = import("love.graphics").Quad;
type Image = import("love.graphics").Image;


type Atlas = {
    draw(quad: Quad, x: number, y: number, r?: number, sx?:number, sy?:number, ox?:number, oy?:number, kx?:number, ky?:number): void;
    flush(): void;
    useBatch(use: boolean): void;
    add(image: Image): void;
}


/** @noSelf **/
declare interface _clientAPI {          
    on(event: string, callback: (...args: any[]) => void): void;
    send(event: string, ...args: any[]): void;
    getUsername(): string;

    readonly atlas: Atlas;

    readonly assets: {
        readonly images: LuaMap<string, Quad>;
        readonly sounds: LuaMap<string, Source>;
    }
}

declare global {
    const client: _clientAPI | undefined;
}

