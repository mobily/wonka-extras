import { TypeOfSource } from 'wonka'

export type TypeOfSourceArray<T extends readonly [...any[]]> = T extends [infer Head, ...infer Tail]
  ? [TypeOfSource<Head>, ...TypeOfSourceArray<Tail>]
  : []
