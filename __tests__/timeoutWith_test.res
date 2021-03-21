open TestFramework
open TestFrameworkExtras

describe("timeoutWith", ({test, testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  testAsync("tbd", ({expect, callback}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)
    let promise200 = makePromise(200)

    Wonka.fromPromise(promise200("stay healthy"))
    |> WonkaExtras.timeoutWith(Wonka.fromValue("timeout"), 300)
    |> Wonka.forEach(spy)

    advanceTimersByTime(200)

    flushPromises(() => {
      toBeCalledTimes(1)
      lastCalledWith("stay healthy")
      callback()
    })
  })

  testAsync("tbd2", ({expect, callback}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)
    let promise200 = makePromise(200)

    Wonka.fromPromise(promise200("stay safe"))
    |> WonkaExtras.timeoutWith(Wonka.fromValue("timeout"), 100)
    |> Wonka.forEach(spy)

    advanceTimersByTime(200)

    flushPromises(() => {
      toBeCalledTimes(1)
      lastCalledWith("timeout")
      callback()
    })
  })

  test("tbd3", ({expect}) => {
    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 2, 3])
    |> WonkaExtras.timeoutWith(Wonka.fromValue(0), 0)
    |> Wonka.forEach(spy)

    toBeCalledTimes(3)
    toBeCalledWith([1, 2, 3])
  })

  // TODO: perhaps there's an issue with jest timers
  // testAsync("tbd4", ({expect, callback}) => {
  //   let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)
  //   let promise200 = makePromise(200)
  //   let promise500 = makePromise(500)

  //   Wonka.fromArray([
  //     Wonka.fromPromise(promise200("stay healthy")),
  //     Wonka.fromPromise(promise500("stay safe")),
  //   ])
  //   |> Wonka.mergeMap((. source) => {
  //     source |> WonkaExtras.timeoutWith(Wonka.fromValue("timeout"), 300)
  //   })
  //   |> Wonka.forEach(spy)

  //   advanceTimersByTime(500)

  //   flushPromises(() => {
  //     toBeCalledTimes(2)
  //     toBeCalledWith(["stay healthy", "timeout"])
  //     callback()
  //   })
  // })
})
