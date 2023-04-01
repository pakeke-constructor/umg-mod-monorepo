


interface Partition<T> {
    clear(): void;
    contains(ent: Entity): boolean;
    update(dt: number): void;
    setPosition(ent: Entity, x: number, y: number): void;
    add(ent: Entity): void;
    remove(ent: Entity): void;
    size(x: number, y: number): void;
    
}


