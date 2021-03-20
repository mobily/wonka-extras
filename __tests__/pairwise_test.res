open TestFramework
open TestFrameworkExtras

describe("pairwise", ({test}) => {
  test("tbd", ({expect}) => {
    let {spy, toBeCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 2, 3, 4, 5]) |> WonkaExtras.pairwise |> Wonka.forEach(spy)

    toBeCalledTimes(4)
    toBeCalledWith([(1, 2), (2, 3), (3, 4), (4, 5)])
  })

  test("tbd", ({expect}) => {
    let {spy, toBeCalledTimes, toBeCalledWith} = makeSpy(expect)
    let {source, next} = WonkaExtras.makeBehaviorSubject(1)

    source |> WonkaExtras.pairwise |> Wonka.forEach(spy)

    next(2)
    next(3)

    toBeCalledTimes(2)
    toBeCalledWith([(1, 2), (2, 3)])
  })
})
