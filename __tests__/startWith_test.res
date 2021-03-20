open TestFramework
open TestFrameworkExtras

describe("startWith", ({test, testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  test("tbd", ({expect}) => {
    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 2, 3]) |> WonkaExtras.startWith(0) |> Wonka.forEach(spy)

    toBeCalledTimes(4)
    toBeCalledWith([0, 1, 2, 3])
  })

  testAsync("tbd", ({expect, callback}) => {
    let promise100 = makePromise(100)
    let promise200 = makePromise(200)

    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.merge([Wonka.fromPromise(promise100("healthy")), Wonka.fromPromise(promise200("safe"))])
    |> Wonka.map((. value) => "stay " ++ value)
    |> WonkaExtras.startWith("stay calm")
    |> Wonka.forEach(spy)

    advanceTimersByTime(200)

    flushPromises(() => {
      toBeCalledTimes(3)
      toBeCalledWith(["stay calm", "stay healthy", "stay safe"])
      callback()
    })
  })
})
