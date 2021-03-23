open Wonka
open Wonka_types
open WonkaExtras_utils

@gentype
let pairwise = (source: sourceT<'a>): sourceT<('a, 'a)> => {
  let shared = share(source)

  shared
  |> scan(scanFn, initialScanValue)
  |> skip(1)
  |> map((. values) => {
    switch values {
    | (Some(prev), Some(current)) => (prev, current)
    | _ => failwith("WonkaExtras.pairwise - something went really wrong!")
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
let reduce = (fn: (. 'b, 'a) => 'b, initialValue: 'b): operatorT<'a, 'b> =>
  curry(source => {
    let shared = share(source)
    shared |> scan(fn, initialValue) |> takeLast(1)
  })

@gentype
let timeoutWith = (rescueSource: sourceT<'b>, ms: int): operatorT<'a, 'b> =>
  curry(source => {
    let shared = share(source)
    let timer = interval(ms) |> take(1)

    merge([
      shared |> takeUntil(timer),
      timer |> takeUntil(source) |> switchMap((. _) => rescueSource),
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
let distinct = (extractFn: (. 'a) => 'b): operatorT<'a, 'a> =>
  curry(source => {
    let shared = share(source)

    shared
    |> scan((. acc, value) => {
      let (arr, previousValue) = acc

      switch previousValue {
      | Some(previousValue) => (arr->Belt.Array.concat([previousValue]), Some(value))
      | None => (arr, Some(value))
      }
    }, ([], None))
    |> map((. values) => {
      let (arr, currentValue) = values
      (arr, currentValue->Belt.Option.getExn)
    })
    |> filter((. values) => {
      let (arr, currentValue) = values
      let extractedValue = extractFn(. currentValue)
      !Belt.Array.someU(arr, (. value) => extractFn(. value) == extractedValue)
    })
    |> map((. values) => {
      let (_, currentValue) = values
      currentValue
    })
  })

@gentype
let flat = (source: sourceT<'a>): sourceT<array<'a>> => {
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

