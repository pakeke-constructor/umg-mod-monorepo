

export {};

type Source = import("love.audio").Source;
type Quad = import("love.graphics").Quad;
type Image = import("love.graphics").Image;


type Atlas = {
    draw(quad: Quad, x: number, y: number, r: number|undefined, sx:number|undefined, sy:number|undefined, ox:number|undefined, oy:number|undefined, kx:number|undefined, ky:number|undefined): void;
    flush(): void;
    useBatch(use: boolean): void;
    add(image: Image): void;
}


/** @noSelf **/
declare namespace _clientAPI {          
    export function on(event: string, callback: (...args: any[]) => void): void;
    export function send(event: string, ...args: any[]): void;
    export function getUsername(): string;

    export const atlas: Atlas;

    export namespace assets {
        export const images: LuaMap<string, Quad>;
        export const sounds: LuaMap<string, Source>;
    }
}

declare global {
    const client: (typeof _clientAPI) | undefined;
}

