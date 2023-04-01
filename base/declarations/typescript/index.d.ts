import { baseClient } from "./client";
import { baseServer } from "./server";
import { baseShared } from "./shared";

export {};


/** @NoSelf */
declare global {
    const base: {
        client: baseClient | undefined;
        server: baseServer | undefined;
    } & baseShared;
}
