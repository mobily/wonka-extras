import {
  Source,
  concat,
  filter,
  fromValue,
  interval,
  map,
  merge,
  pipe,
  scan,
  skip,
  take,
  takeLast,
  takeUntil,
} from 'wonka'

export const startWith =
  <A>(value: A) =>
  (source: Source<A>) => {
    const initialValue = fromValue(value)
    return concat([initialValue, source])
  }

export const endWith =
  <A>(value: A) =>
  (source: Source<A>) => {
    const endValue = fromValue(value)
    return concat([source, endValue])
  }

export const pairwise = <A>(source: Source<A>) => {
  return pipe(
    source,
    scan((acc, value) => {
      return [acc[1], value] as const
    }, [] as unknown as readonly [A, A]),
    skip(1),
  )
}

export const reduce =
  <A, B>(reduceFn: (acc: A, value: B) => A, initialValue: A) =>
  (source: Source<B>) => {
    return pipe(source, scan(reduceFn, initialValue), takeLast(1))
  }

export const timeoutWith =
  <A>(rescueValue: A, ms: number) =>
  (source: Source<A>) => {
    const timer = pipe(interval(ms), take(1))
    const value = pipe(source, takeUntil(timer))
    const rescue = pipe(
      timer,
      takeUntil(source),
      map(_ => rescueValue),
    )

    return merge([value, rescue])
  }

export const distinctUntilChanged =
  <A>(comparatorFn: (prev: A, current: A) => boolean) =>
  (source: Source<A>) => {
    return pipe(
      source,
      scan(
        (acc, value) => {
          acc.prev = acc.current
          acc.current = value
          return acc
        },
        {
          prev: undefined as A,
          current: undefined as A,
        },
      ),
      filter(obj => {
        return obj.prev != undefined ? !comparatorFn(obj.prev, obj.current) : true
      }),
      map(obj => obj.current),
    )
  }

export const distinct =
  <A, B>(extractFn: (value: A) => B) =>
  (source: Source<A>) => {
    return pipe(
      source,
      scan(
        (acc, value) => {
          const element = extractFn(value)
          const hasElement = acc.xs.some(value => value === element)

          if (!hasElement) {
            acc.xs.push(element)
          }

          acc.skip = hasElement
          acc.value = value

          return acc
        },
        {
          xs: [] as B[],
          skip: false,
          value: undefined as A,
        },
      ),
      filter(obj => !obj.skip),
      map(obj => obj.value),
    )
  }
