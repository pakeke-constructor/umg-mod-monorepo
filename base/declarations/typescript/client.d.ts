
import { ParticleSystem, Quad } from "love.graphics";
import { input as inputAPI } from "./input";
import { control as controlAPI } from "./control";


/** @NoSelf */
export namespace baseClient {
    export const camera: Camera;
    export const input: typeof inputAPI;
    export const control: typeof controlAPI;

    function isHovered(ent: Entity): boolean;

    function getUIScale(): number;
    function setUIScale(uiScale: number): void;

    function isOnScreen(x: number, y: number): boolean;
    function entIsOnScreen(ent: Entity): boolean;
    
    function getDrawY(y: number, z: number | undefined): number;
    function getDrawDepth(y: number, z: number | undefined): number;
    type BaseImage = Quad | string;
    function getQuadOffsets(image: BaseImage): LuaMultiReturn<[number, number]>;
    function drawImage(image: BaseImage, x: number, y: number, rot?: number, sx?: number, sy?: number, ox?: number, oy?: number, kx?: number, ky?: number): void;

    namespace groundTexture {
        function setColor(color: Color): void;
        function setTextureList(textures: string[]): void;
    }

    function animate(frames: string[], time: number, x: number, y: number, z?: number, color?: Color): void;
    function animateEntity(ent: Entity, frames: string[], time: number): void;

    function shockwave(options: {
        x: number, y: number,
        color?: Color, thickness?: number,
        startRadius?: number, endRadius?: number,
        duration?: number, fadeRings?: number,
        radius?: number
    }): void;

    namespace particles {
        function emit(name: string, x: number, y: number, z?: number, numParticles?: number, color?: Color): void;
        function getParticleSystem(name: string): ParticleSystem | undefined;
    }

    function playSound(name: string, volume?: number, pitch?: number, effect?: any): void;
    function playMusic(name: string, startTime?: number, volume?: number): void;

    function title(text: string, options?: {
        fade?: number,
        color?: Color,
        x?: number, y?: number,
        scale?: number
    }): void;
}
