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
  let source = merge([fromValue(value), subject.source])

  let next = value => {
    if value != previousValue.contents {
      previousValue := value
      subject.next(value)
    }
  }

  {source: source, next: next, complete: subject.complete}
}

let forkJoin = () => {
  ()
}

let combineLatest = () => {
  ()
}
