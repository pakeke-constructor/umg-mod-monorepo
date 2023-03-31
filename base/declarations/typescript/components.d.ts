
export {};


export namespace components {
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

    interface Color2 {
        color: Color
    }
}


