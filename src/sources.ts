import {
  Source,
  Subject,
  combine,
  concat,
  fromValue,
  interval,
  make,
  pipe,
  share,
  take,
} from 'wonka'

import { TypeOfSourceArray } from './types'

export const timer = (ms: number) => {
  return pipe(interval(ms), take(1))
}

export const forkJoin = <T extends Source<any>[]>(...sources: T): Source<TypeOfSourceArray<T>> => {
  return pipe(combine(...sources), take(1))
}

export const makeBehaviorSubject = <T>(value: T): Subject<T> => {
  let next: Subject<T>['next'] | void
  let complete: Subject<T>['complete'] | void
  let previousValue = value

  const source = concat<T>([
    fromValue(previousValue),
    make(observer => {
      next = observer.next
      complete = observer.complete

      return () => {
        // noop
      }
    }),
  ])

  return {
    source: share(source),
    next(value: T) {
      if (next) {
        previousValue = value
        next(value)
      }
    },
    complete() {
      if (complete) {
        complete()
      }
    },
  }
}
