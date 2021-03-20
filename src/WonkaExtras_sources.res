open Wonka
open Wonka_types

type behaviorSubjectT<'a> = {
  source: sourceT<'a>,
  next: 'a => unit,
  complete: unit => unit,
}

@gentype
let makeBehaviorSubject = (value: 'a): behaviorSubjectT<'a> => {
  let subject = makeSubject()
  let previousValue = ref(value)
  let source = concat([fromValue(value), subject.source])

  let next = value => {
    if value != previousValue.contents {
      previousValue := value
      subject.next(value)
    }
  }

  {source: source, next: next, complete: subject.complete}
}

@gentype
let forkJoin = (sources: array<sourceT<'a>>): sourceT<array<'a>> => {
  open WonkaExtras_operators

  fromArray(sources)
  |> concatMap((. value) => {
    value
    |> reduce((. _, value) => Some(value), None)
    |> map((. value) => value->Belt.Option.getExn)
  })
  |> takeArray
}

@gentype
let combineLatest = (sources: array<sourceT<'a>>): sourceT<array<'a>> => {
  let sources =
    sources->Belt.Array.mapWithIndexU((. index, source) =>
      source |> map((. value) => (index, value))
    )
  let length = Belt.Array.length(sources)
  let initial = length->Belt.Array.makeByU((. _) => None)

  merge(sources)
  |> scan((. acc, value) => {
    let (index, _) = value
    Belt.Array.setUnsafe(acc, index, Some(value))
    acc
  }, initial)
  |> map((. tuples) => {
    tuples->Belt.Array.keepMapU((. tuple) =>
      tuple->Belt.Option.mapU((. tuple) => {
        let (_, value) = tuple
        value
      })
    )
  })
  |> skipWhile((. tuples) => Belt.Array.length(tuples) < length)
}
