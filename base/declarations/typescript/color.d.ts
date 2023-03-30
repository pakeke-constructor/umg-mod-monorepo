

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
