// Based on https://www.lua.org/manual/5.3/manual.html#6.3

/** @noSelfInFile */

/**
 * Loads the given module.
 *
 * If there is any error loading or running the module, or if it cannot find any
 * loader for the module, then require raises an error.
 */
declare function require(modname: string): any;
