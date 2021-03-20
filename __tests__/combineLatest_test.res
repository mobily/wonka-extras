open TestFramework
open TestFrameworkExtras

describe("combineLatest", ({testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  testAsync("tbd1", ({expect, callback}) => {
    let {spy, toBeCalledTimes, lastCalledWith} = makeSpy(expect)
    let promise200 = makePromise(200)
    let promise500 = makePromise(500)

    WonkaExtras.combineLatest([
      Wonka.fromPromise(promise500("stay safe")),
      Wonka.fromPromise(promise200("stay calm")),
      Wonka.fromValue("stay healthy"),
    ]) |> Wonka.forEach(spy)

    advanceTimersByTime(500)

    flushPromises(() => {
      toBeCalledTimes(1)
      lastCalledWith(["stay safe", "stay calm", "stay healthy"])
      callback()
    })
  })

  testAsync("tbd2", ({expect, callback}) => {
    let {spy, toBeCalledTimes, toBeCalledWith} = makeSpy(expect)
    let {source, next} = Wonka.makeSubject()

    let promise500 = makePromise(500)

    WonkaExtras.combineLatest([
      Wonka.fromValue(1),
      Wonka.fromPromise(promise500(2)),
      source,
    ]) |> Wonka.forEach(spy)

    advanceTimersByTime(500)

    flushPromises(() => {
      next(3)
      next(4)

      toBeCalledTimes(2)
      toBeCalledWith([[1, 2, 3], [1, 2, 4]])
      callback()
    })
  })

  testAsync("tbd3", ({expect, callback}) => {
    let {spy, toBeCalledTimes, lastCalledWith} = makeSpy(expect)
    let {source, next} = Wonka.makeSubject()

    let promise500 = makePromise(500)
    let promise200 = makePromise(200)

    Wonka.fromPromise(promise200(1))
    |> Wonka.mergeMap((. value) => {
      WonkaExtras.combineLatest([Wonka.fromPromise(promise500(value)), source])
    })
    |> Wonka.forEach(spy)

    advanceTimersByTime(2000)
    next(2)
    advanceTimersByTime(2000)

    next(3)
    advanceTimersByTime(2000)

    flushPromises(() => {
      toBeCalledTimes(2)
      // lastCalledWith([1, 2])
      callback()
      // next(3)
      // advanceTimersByTime(700)

      // flushPromises(() => {
      //   toBeCalledTimes(2)
      //   lastCalledWith([1, 3])
      //   callback()
      // })
    })
  })
})
