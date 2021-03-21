open TestFramework
open TestFrameworkExtras

describe("concatMapTo", ({test, testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  test("tbd", ({expect}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)
    let sourceA = Wonka.fromValue(2)

    Wonka.fromValue(1) |> WonkaExtras.concatMapTo(sourceA) |> Wonka.forEach(spy)

    toBeCalledTimes(1)
    lastCalledWith(2)
  })

  testAsync("tbd2", ({expect, callback}) => {
    let {spy, toBeCalledTimes, lastCalledWith} = makeSpy(expect)

    let promise200 = makePromise(200)
    let promise500 = makePromise(500)
    let sourceA = Wonka.fromPromise(promise500(2))

    Wonka.fromPromise(promise200(1)) |> WonkaExtras.concatMapTo(sourceA) |> Wonka.forEach(spy)

    advanceTimersByTime(700)

    flushPromises(() => {
      toBeCalledTimes(1)
      lastCalledWith(2)
      callback()
    })
  })
})
