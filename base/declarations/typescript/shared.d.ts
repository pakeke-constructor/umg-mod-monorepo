/** @noSelfInFile */

import { gravity } from "./shared/gravity";

export interface baseShared {
    readonly gravity: gravity;
    
    getGameTime(): number;

}
