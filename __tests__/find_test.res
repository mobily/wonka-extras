open TestFramework
open TestFrameworkExtras

describe("find", ({test, testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  test("tbd1", ({expect}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 2, 3, 4, 5])
    |> WonkaExtras.find((. value) => {
      value > 2
    })
    |> Wonka.forEach(spy)

    toBeCalledTimes(1)
    lastCalledWith(Some(3))
  })

  testAsync("tbd2", ({expect, callback}) => {
    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)
    let subject = WonkaExtras.makeBehaviorSubject(0)
    let promise100 = makePromise(100)

    subject.source
    |> Wonka.mergeMap((. value) =>
      Wonka.fromPromise(promise100(value)) |> Wonka.switchMap((. value) => {
        Wonka.fromArray(
          Belt.Array.makeBy(5, index => value * index),
        ) |> WonkaExtras.find((. value) => value > 2)
      })
    )
    |> Wonka.forEach(spy)

    subject.next(1)
    subject.next(2)
    subject.next(5)

    advanceTimersByTime(300)

    flushPromises(() => {
      toBeCalledTimes(4)
      toBeCalledWith([None, Some(3), Some(4), Some(5)])

      callback()
    })
  })

  testAsync("tbd3", ({expect, callback}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)
    let promise100 = makePromise(100)
    let promise300 = makePromise(300)
    let promise500 = makePromise(500)

    Wonka.fromArray([
      Wonka.fromPromise(promise100(1)),
      Wonka.fromPromise(promise300(3)),
      Wonka.fromPromise(promise500(5)),
    ])
    |> Wonka.mergeAll
    |> WonkaExtras.find((. value) => value > 2)
    |> Wonka.forEach(spy)

    advanceTimersByTime(500)

    flushPromises(() => {
      toBeCalledTimes(1)
      lastCalledWith(Some(3))

      callback()
    })
  })
})
