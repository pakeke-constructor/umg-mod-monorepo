

//TODO: finish this
interface Partition<T> {
    clear(): void;
    contains(obj: T): boolean;
    update(dt: number): void;
    setPosition(obj: T, x: number, y: number): void;
    add(obj: T): void;
    remove(obj: T): void;
    size(x: number, y: number): void;
}


