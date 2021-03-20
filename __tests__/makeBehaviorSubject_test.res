open TestFramework
open TestFrameworkExtras

describe("makeBehaviorSubject", ({test}) => {
  test("gets an initial value", ({expect}) => {
    let {spy, toBeCalledTimes, lastCalledWith} = makeSpy(expect)
    let {source} = WonkaExtras.makeBehaviorSubject("hello!")

    source |> Wonka.forEach(spy)

    toBeCalledTimes(1)
    lastCalledWith("hello!")
  })

  test("emits a new value", ({expect}) => {
    let {spy, toBeCalledTimes, lastCalledWith} = makeSpy(expect)

    let {source, next} = WonkaExtras.makeBehaviorSubject("stay calm")

    source |> Wonka.forEach(spy)

    toBeCalledTimes(1)
    lastCalledWith("stay calm")

    next("stay healthy")

    toBeCalledTimes(2)
    lastCalledWith("stay healthy")

    next("stay safe")

    toBeCalledTimes(3)
    lastCalledWith("stay safe")
  })
})
