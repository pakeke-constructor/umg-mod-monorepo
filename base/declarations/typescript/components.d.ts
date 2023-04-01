import { BodyType, Shape } from "love.physics";
import {Color as ColorObject} from "./color";
import { MouseButton } from "./input";

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

    interface Vx {
        vx: number
    }
    interface Vy {
        vy: number;
    }
    interface Vz {
        vz?: number;
    }

    type Vel = Vx&Vy&Vz;

    interface Rot {
        rot?: number
    }
    
    interface Image {
        image: string;
    }

    interface Color {
        color?: ColorObject
    }

    interface Ox {
        ox?: number;
    }
    interface Oy {
        oy?: number;
    }

    interface Animation {
        animation: {
            frames: string[];
            speed?: number;
        }
    }

    interface MoveAnimation {
        moveAnimation: {
            up: string[];
        }
    }

    interface Shadow {
        shadow: {
            size?: number,
            color?: Color
        }
    }

    interface Rainbow {
        rainbow: {
            period?: number,
            brightness?: number
        }
    }

    interface Swaying {
        swaying: {
            magnitude?: number,
            period?: number
        }
    }


    interface Bobbing {
        bobbing: {
            magnitude?: number,
            period?: number
        }
    }

    interface Spinning {
        spinning: {
            magnitude?: number,
            period?: number
        }
    }

    interface Scale {
        scale?: number,
        scaleX?: number,
        scaleY?: number
    }

    interface Riding {
        riding?: Entity & XY;
    }

    interface Friction {
        friction: number;
    }

    interface Health {
        maxHealth: number,
        health: number
    }

    interface HealthBar {
        healthBar: {
            offset?: number,
            drawWidth?: number,
            drawHeight?: number,
            healthColor?: number,
            outlineColor?: number,
            backgroundColor?: number
        }
    }

    interface Nametag {
        nametag: {
            value?: string;
        }
    }

    interface Text {
        text: {
            value: string,
            ox?: number, oy?: number,
            scale?: number, overlay?: boolean
        }
    }

    interface Particles {
        particles: {
            type: string;
            rate?: number,
            spread?: XY,
            offset?: XY
        },
        shouldEmitParticles(ent: Entity&XY&Particles): boolean;
    }

    interface Physics {
        physics: {
            shape: Shape;
            friction?: number,
            type?: BodyType
        }
    }

    interface Controllable {
        controllable: {
            onLeftButton: (ent: Entity&Controllable) => void,
            onRightButton: (ent: Entity&Controllable) => void,
            onUpBotton: (ent: Entity&Controllable) => void,
            onDownButton: (ent: Entity&Controllable) => void,
            onClick: (ent: Entity&Controllable) => void,
        }

        controller: string; // TODO: Should this be a client object instead?
    }

    interface Follow {
        follow?: boolean
    }

    interface Speed {
        speed: number
    }

    interface Agility {
        agility: number
    }

    interface BaseCallbacks {
        onDeath: (ent: Entity) => void,
        onUpdate: (ent: Entity, dt: number) => void,
        onDraw: (ent: Entity&XY) => void,
        onCollide: (ent: Entity&XY&Physics, other: Entity) => void,
        onClick: (ent: Entity&XY, player: PlayerObject, button: MouseButton, x: number, y: number) => void
    }
}


