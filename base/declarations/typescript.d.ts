import { ParticleSystem, Quad } from "love.graphics";
import { Scancode } from "love.keyboard";

export {};



declare module "base" {
    interface Camera {
        attach(): void;
        detach(): void;
        move(dx: number, dy: number): void;
        toWorldCoords(x: number, y: number): LuaMultiReturn<[number, number]>;
        toCameraCoords(x: number, y: number): LuaMultiReturn<[number, number]>;
        getMousePosition(): LuaMultiReturn<[number, number]>;
        shake(intensity: number, duration: number, frequency: number, axes: 'XY' | 'X' | 'Y'): void;
        update(dt: number): void;
        draw(): void;
        follow(x: number, y: number): void;
        setDeadzone(x: number,y: number, w: number, h: number): void;
        setBounds(x: number,y: number, w: number, h: number): void;
        setFollowLerp(x: number,y: number): void;
        setFollowLead(x: number, y: number): void;
        setFollowStyle(style: 'LOCKON' | 'TOPDOWN' | 'NO_DEADZONE' | 'PLATFORMER' | 'TOPDOWN_TIGHT' | 'SCREEN_BY_SCREEN'): void;
        flash(duration: number, color: LuaTable): void;
        fade(duration: number, color: LuaTable, action: any): void;
    }

    export const camera: Camera;


    type InputEnum = 'UP'|'LEFT'|'DOWN'|'RIGHT'|'BUTTON_SPACE'|'BUTTON_SHIFT'|'BUTTON_CONTROL'|'BUTTON_LEFT'|'BUTTON_RIGHT'|'BUTTON_1'|'BUTTON_2'|'BUTTON_3'|'BUTTON_4';
    type MouseButton = 1 | 2 | 3 | 4 | 5 

    interface Listener {
        lockKey(scancode: Scancode): void;
        lockMouseButton(button: MouseButton): void;
        getKey(inputEnum: InputEnum): Scancode | undefined;
        getInputEnum(scancode: Scancode): InputEnum | undefined;
        isKeyLocked(scancode: Scancode): boolean;
        isMouseButtonLocked(button: MouseButton): boolean;
        isControlDown(inputEnum: InputEnum): boolean;
        isKeyDown(scancode: Scancode): boolean;
        isMouseButtonDown(button: MouseButton): boolean;
        lockKeyboard(): void;
        lockMouseButtons(): void;
        lockMouseWheel(): void;
        lockMouseMovement(): void;
        lockMouse(): void;
    }

    namespace input {
        function Listener(options: LuaTable): Listener;
        function unlockEverything(): void;
        function setControls(inputMapping: LuaTable<InputEnum, Scancode>): void;
    }

    namespace control {
        function setFollowActive(active: boolean): void;
    }

    function isHovered(ent: Entity): boolean;

    function getUIScale(): number;
    function setUIScale(uiScale: number): void;

    function isOnScreen(x: number, y: number): boolean;
    function entIsOnScreen(ent: Entity): boolean;
    
    function getDrawY(y: number, z: number | undefined): number;
    function getDrawDepth(y: number, z: number | undefined): number;

    interface Color {
        (r?: number, g?: number, b?: number, a?:number): Color;
        hex: string;
        
        r: number, g: number, b: number, a: number,
        red: number, green: number, blue: number, alpha: number,

        h: number, hue: number,
        s: number, saturation: number,
        l: number, lightness: number,

        ss: number, ssaturation: number,
        v: number, value: number

        add(other: Color): Color;
        subtract(other: Color): Color;
        multiplying(other: Color): Color;
        divide(other: Color): Color;
        invert(other: Color): Color;
        shiftHue(degrees: number): Color;

        setHSV(h: number, s: number, v: number): Color;
        getHSV(): LuaMultiReturn<[number, number, number]>;
        
        setHSL(h: number, s: number, v: number): Color;
        getHSL(): LuaMultiReturn<[number, number, number]>;
       
        setRGBA(r?: number, g?: number, b?: number, a?: number): Color;
        getRGBA(): LuaMultiReturn<[number, number, number, number]>;

        setByteRGBA(r?: number, g?: number, b?: number, a?: number): Color;
        getByteRGBA(): LuaMultiReturn<[number, number, number, number]>;

        clone(): Color;

        /** @NoSelf */
        lerp(from: Color, to: Color, progress: number): Color;
        /** @NoSelf */
        distance(a: Color, b: Color): number;
    }

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

    /** @Noself */
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
