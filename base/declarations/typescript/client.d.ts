
import { ParticleSystem, Quad } from "love.graphics";
import { input as inputAPI } from "./input";
import { control as controlAPI } from "./control";


type BaseImage = Quad | string;


/**
 * @NoSelf 
 */
export interface baseClient {
    readonly camera: Camera;
    readonly input: inputAPI;
    readonly control: controlAPI;

    isHovered(ent: Entity): boolean;

    getUIScale(): number;
    setUIScale(uiScale: number): void;

    isOnScreen(x: number, y: number): boolean;
    entIsOnScreen(ent: Entity): boolean;
    
    getDrawY(y: number, z: number | undefined): number;
    getDrawDepth(y: number, z: number | undefined): number;
    getQuadOffsets(image: BaseImage): LuaMultiReturn<[number, number]>;
    drawImage(image: BaseImage, x: number, y: number, rot?: number, sx?: number, sy?: number, ox?: number, oy?: number, kx?: number, ky?: number): void;

    readonly groundTexture: {
        setColor(color: Color): void;
        setTextureList(textures: string[]): void;
    }

    animate(frames: string[], time: number, x: number, y: number, z?: number, color?: Color): void;
    animateEntity(ent: Entity, frames: string[], time: number): void;

    shockwave(options: {
        x: number, y: number,
        color?: Color, thickness?: number,
        startRadius?: number, endRadius?: number,
        duration?: number, fadeRings?: number,
        radius?: number
    }): void;

    readonly particles: {
        emit(name: string, x: number, y: number, z?: number, numParticles?: number, color?: Color): void;
        getParticleSystem(name: string): ParticleSystem | undefined;
    }

    playSound(name: string, volume?: number, pitch?: number, effect?: any): void;
    playMusic(name: string, startTime?: number, volume?: number): void;

    title(text: string, options?: {
        fade?: number,
        color?: Color,
        x?: number, y?: number,
        scale?: number
    }): void;
}
