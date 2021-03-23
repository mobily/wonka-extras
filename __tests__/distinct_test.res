open TestFramework
open TestFrameworkExtras

describe("distinct", ({test}) => {
  test("tbd1", ({expect}) => {
    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 2, 3, 4, 5, 1, 2, 3, 4, 5])
    |> WonkaExtras.distinct((. x) => x)
    |> Wonka.forEach(spy)

    toBeCalledTimes(5)
    toBeCalledWith([1, 2, 3, 4, 5])
  })

  test("tbd2", ({expect}) => {
    let {spy, toBeCalledTimes, toBeCalledWith} = makeSpy(expect)
    let {source, next} = WonkaExtras.makeBehaviorSubject(1)

    source |> WonkaExtras.distinct((. x) => x) |> Wonka.forEach(spy)

    next(1)
    next(2)
    next(3)
    next(1)
    next(2)
    next(3)
    next(4)

    toBeCalledTimes(4)
    toBeCalledWith([1, 2, 3, 4])
  })
})

