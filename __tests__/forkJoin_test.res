open TestFramework
open TestFrameworkExtras

describe("forkJoin", ({testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  testAsync("tbd1", ({expect, callback}) => {
    let {spy, toBeCalledTimes, lastCalledWith} = makeSpy(expect)
    let promise200 = makePromise(200)
    let promise500 = makePromise(500)

    WonkaExtras.forkJoin([
      Wonka.fromPromise(promise500("stay safe")),
      Wonka.fromArray(["x", "y", "z"]),
      Wonka.fromPromise(promise200("stay calm")),
      Wonka.fromValue("stay healthy"),
    ]) |> Wonka.forEach(spy)

    advanceTimersByTime(500)

    flushPromises(() => {
      toBeCalledTimes(1)
      lastCalledWith(["stay safe", "z", "stay calm", "stay healthy"])
      callback()
    })
  })

  testAsync("tbd2", ({expect, callback}) => {
    let {spy, toBeCalledTimes, toBeCalledWith} = makeSpy(expect)
    let {source, next} = WonkaExtras.makeBehaviorSubject(10)

    let promise200 = makePromise(200)
    let promise500 = makePromise(500)

    source
    |> Wonka.mergeMap((. value) => {
      WonkaExtras.forkJoin([
        Wonka.fromPromise(promise500(1)),
        Wonka.fromArray([2, 3]),
        Wonka.fromPromise(promise200(4)),
        Wonka.fromValue(value),
      ])
    })
    |> Wonka.forEach(spy)

    next(20)
    next(30)

    advanceTimersByTime(1500)

    flushPromises(() => {
      toBeCalledTimes(3)
      toBeCalledWith([[1, 3, 4, 10], [1, 3, 4, 20], [1, 3, 4, 30]])
      callback()
    })
  })
})
