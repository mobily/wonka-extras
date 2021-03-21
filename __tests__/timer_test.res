open TestFramework
open TestFrameworkExtras

describe("timer", ({test, beforeEach, afterEach}) => {
  beforeEach(useFakeTimers)
  afterEach(clearAllTimers)

  test("tbd", ({expect}) => {
    let {spy, lastCalledWith, toBeCalledTimes} = makeSpy(expect)

    WonkaExtras.timer(2000) |> Wonka.forEach(spy)

    advanceTimersByTime(100)
    toBeCalledTimes(0)
    advanceTimersByTime(1000)
    toBeCalledTimes(0)
    advanceTimersByTime(900)
    toBeCalledTimes(1)
    lastCalledWith(0)
  })
})
