import {Color as ColorObject} from "./color";

export {};

/**
 * @noSelf
 */
declare module "components" {
    interface X {
        x: number;
    }
    interface Y {
        y: number
    }

    interface Z {
        z: number
    }

    type XY = X & Y;
    type XYZ = XY & Z;

    interface Image {
        image: string;
    }

    interface Color {
        color: ColorObject
    }
}


