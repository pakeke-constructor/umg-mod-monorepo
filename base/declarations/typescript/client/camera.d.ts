
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
