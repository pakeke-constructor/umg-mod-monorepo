
import { Scancode } from "love.keyboard";

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

/** @NoSelf */
export interface input {
    Listener(options: LuaTable): Listener;
    unlockEverything(): void;
    setControls(inputMapping: LuaTable<InputEnum, Scancode>): void;
}

