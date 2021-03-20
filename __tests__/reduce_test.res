open TestFramework
open TestFrameworkExtras

describe("reduce", ({test}) => {
  test("tbd", ({expect}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)

    Wonka.fromArray([1, 2, 3, 4, 5]) |> WonkaExtras.reduce((. acc, value) => {
      Belt.Array.concat(acc, [value * 10])
    }, []) |> Wonka.forEach(spy)

    toBeCalledTimes(1)
    lastCalledWith([10, 20, 30, 40, 50])
  })
})
