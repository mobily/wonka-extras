import { Subject, TypeOfSource } from 'wonka'

export type BehaviorSubject<T> = Subject<T> & {
  value: T
}

export type TypeOfSourceArray<T extends readonly [...any[]]> = T extends [infer Head, ...infer Tail]
  ? [TypeOfSource<Head>, ...TypeOfSourceArray<Tail>]
  : []
