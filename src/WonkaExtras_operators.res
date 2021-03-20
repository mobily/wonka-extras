open Wonka
open Wonka_types

let scanFn = (. acc, value) => {
  switch acc {
  | (_, Some(current)) => (Some(current), Some(value))
  | _ => (None, Some(value))
  }
}
let initialScanValue = (None, None)

@gentype
let pairwise = (source: sourceT<'a>): sourceT<('a, 'a)> => {
  let shared = share(source)

  shared
  |> scan(scanFn, initialScanValue)
  |> skip(1)
  |> map((. values) => {
    switch values {
    | (Some(prev), Some(current)) => (prev, current)
    | _ => failwith("WonkaExtras.pairwise – something went really wrong!")
    }
  })
}

@gentype
let startWith = (value: 'a): operatorT<'a, 'a> =>
  curry(source => {
    let shared = share(source)
    concat([fromValue(value), shared])
  })

@gentype
let endWith = (value: 'a): operatorT<'a, 'a> =>
  curry(source => {
    let shared = share(source)
    concat([shared, fromValue(value)])
  })

@gentype
let reduce = (fn: (. 'b, 'a) => 'b, initial: 'b): operatorT<'a, 'b> =>
  curry(source => {
    let shared = share(source)
    shared |> scan(fn, initial) |> takeLast(1)
  })

@gentype
let timeoutWith = (rescueFn: (. unit) => sourceT<'b>, ms: int): operatorT<'a, 'b> =>
  curry(source => {
    let shared = share(source)
    let timer = interval(ms) |> take(1)

    merge([
      shared |> takeUntil(timer),
      timer |> takeUntil(source) |> switchMap((. _) => rescueFn(.)),
    ])
  })

@gentype
let find = (predicateFn: (. 'a) => bool): operatorT<'a, option<'a>> =>
  curry(source => {
    let shared = share(source)
    let subject = makeSubject()

    shared
    |> takeUntil(subject.source)
    |> mergeMap((. value) => {
      fromValue(value)
      |> map((. value) => {
        predicateFn(. value) ? Some(value) : None
      })
      |> onPush((. value) => {
        if Belt.Option.isSome(value) {
          subject.next(0)
          subject.complete()
        }
      })
    })
    |> takeLast(1)
  })

@gentype
let distinctUntilChanged = (comparatorFn: (. 'a, 'a) => bool): operatorT<'a, 'a> =>
  curry(source => {
    let shared = share(source)

    shared
    |> scan(scanFn, initialScanValue)
    |> map((. values) => {
      fromValue(values)
      |> skipWhile((. values) => {
        switch values {
        | (Some(prev), Some(current)) => comparatorFn(. prev, current)
        | _ => false
        }
      })
      |> map((. values) => {
        let (_, current) = values
        current->Belt.Option.getExn
      })
    })
    |> concatAll
  })

@gentype
let takeArray = (source: sourceT<'a>): sourceT<array<'a>> => {
  let shared = share(source)
  shared |> reduce((. acc, value) => Belt.Array.concat(acc, [value]), [])
}

@gentype
let mapTo = (value: 'b): operatorT<'a, 'b> =>
  curry(source => {
    let shared = share(source)
    shared |> map((. _) => value)
  })

@gentype
let switchMapTo = (sndSource: sourceT<'b>): operatorT<'a, 'b> =>
  curry(source => {
    let shared = share(source)
    shared |> switchMap((. _) => sndSource)
  })

@gentype
let concatMapTo = (sndSource: sourceT<'b>): operatorT<'a, 'b> =>
  curry(source => {
    let shared = share(source)
    shared |> concatMap((. _) => sndSource)
  })
