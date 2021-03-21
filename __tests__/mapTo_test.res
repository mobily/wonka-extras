open TestFramework
open TestFrameworkExtras

describe("mapTo", ({test, testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  test("tbd", ({expect}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromValue(1) |> WonkaExtras.mapTo(2) |> Wonka.forEach(spy)

    toBeCalledTimes(1)
    lastCalledWith(2)
  })

  testAsync("tbd2", ({expect, callback}) => {
    let {spy, toBeCalledTimes, toBeCalledWith} = makeSpy(expect)
    let {source, next} = Wonka.makeSubject()
    let promise200 = makePromise(200)

    Wonka.fromPromise(promise200(1))
    |> Wonka.switchMap((. _) => {
      source |> WonkaExtras.mapTo(2)
    })
    |> Wonka.forEach(spy)

    advanceTimersByTime(200)

    flushPromises(() => {
      next(0)
      next(1)

      toBeCalledTimes(2)
      toBeCalledWith([2, 2])
      callback()
    })
  })
})
