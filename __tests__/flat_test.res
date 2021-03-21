open TestFramework
open TestFrameworkExtras

describe("flat", ({testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  testAsync("tbd", ({expect, callback}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)
    let promise200 = makePromise(200)
    let promise500 = makePromise(500)

    Wonka.fromArray([
      Wonka.fromValue(1),
      Wonka.fromPromise(promise500(2)),
      Wonka.fromArray([3, 4, 5]),
      Wonka.fromPromise(promise200(6)),
    ])
    |> Wonka.concatAll
    |> WonkaExtras.flat
    |> Wonka.forEach(spy)

    advanceTimersByTime(500)

    flushPromises(() => {
      toBeCalledTimes(1)
      lastCalledWith([1, 2, 3, 4, 5, 6])
      callback()
    })
  })
})
