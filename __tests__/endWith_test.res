open TestFramework
open TestFrameworkExtras

describe("endWith", ({test, testAsync, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  test("tbd", ({expect}) => {
    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 2, 3]) |> WonkaExtras.endWith(4) |> Wonka.forEach(spy)

    toBeCalledTimes(4)
    toBeCalledWith([1, 2, 3, 4])
  })

  testAsync("tbd", ({expect, callback}) => {
    let promise100 = makePromise(100)
    let promise200 = makePromise(200)

    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.merge([Wonka.fromPromise(promise100("healthy")), Wonka.fromPromise(promise200("safe"))])
    |> Wonka.map((. value) => "stay " ++ value)
    |> WonkaExtras.endWith("stay calm")
    |> Wonka.forEach(spy)

    advanceTimersByTime(200)

    flushPromises(() => {
      toBeCalledTimes(3)
      toBeCalledWith(["stay healthy", "stay safe", "stay calm"])
      callback()
    })
  })
})
