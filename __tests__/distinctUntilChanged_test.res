open TestFramework
open TestFrameworkExtras

describe("distinctUntilChanged", ({test}) => {
  test("tbd1", ({expect}) => {
    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 1, 2, 2, 2, 3, 3, 3, 4, 5, 5, 1])
    |> WonkaExtras.distinctUntilChanged((. x, y) => x == y)
    |> Wonka.forEach(spy)

    toBeCalledTimes(6)
    toBeCalledWith([1, 2, 3, 4, 5, 1])
  })

  test("tbd2", ({expect}) => {
    let {spy, toBeCalledTimes, toBeCalledWith} = makeSpy(expect)
    let {source, next} = WonkaExtras.makeBehaviorSubject(1)

    source |> WonkaExtras.distinctUntilChanged((. x, y) => x == y) |> Wonka.forEach(spy)

    next(1)
    next(2)
    next(3)
    next(3)
    next(4)
    next(4)
    next(5)
    next(1)

    toBeCalledTimes(6)
    toBeCalledWith([1, 2, 3, 4, 5, 1])
  })
})
