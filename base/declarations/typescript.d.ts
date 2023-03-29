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

    function getQuadOffsets()
}
