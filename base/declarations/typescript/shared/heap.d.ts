
type HeapComparator<T> = (a: T, b: T) => boolean | undefined;

interface Heap<T> {
    insert(value: T): void;
    pop(): T|null;
    peek(): T|null;
    clear(): void;
    clone(): Heap<T>;
    heapify(arr: T[], comparator: HeapComparator<T>): Heap<T>;
}

/** @noSelf */
export function Heap<T>(comparator: HeapComparator<T>): Heap<T>;
