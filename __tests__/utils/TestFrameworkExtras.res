type t<'a> = {
  spy: (. 'a) => unit,
  toBeCalledWith: array<'a> => unit,
  toBeCalledTimes: int => unit,
  lastCalledWith: 'a => unit,
  nthCalledWith: (int, 'a) => unit,
}

let makeSpy = (expect: TestFramework.Types.expectUtils<'a>) => {
  open Belt.Array

  let spy = TestFramework.Mock.fn()
  let toBeCalledTimes = n => expect.int(spy->TestFramework.Mock.calls->length).toBe(n)
  let lastCalledWith = value =>
    expect.value(spy->TestFramework.Mock.calls->sliceToEnd(-1)->getUnsafe(0)->getUnsafe(0)).toEqual(
      value,
    )
  let nthCalledWith = (n, value) => {
    expect.value(spy->TestFramework.Mock.calls->getUnsafe(pred(n))->getUnsafe(0)).toEqual(value)
  }
  let toBeCalledWith = values => {
    expect.value(
      spy->TestFramework.Mock.calls->Belt.Array.map(value => Belt.Array.getUnsafe(value, 0)),
    ).toEqual(values)
  }

  {
    spy: spy,
    toBeCalledWith: toBeCalledWith,
    toBeCalledTimes: toBeCalledTimes,
    lastCalledWith: lastCalledWith,
    nthCalledWith: nthCalledWith,
  }
}

@val external setImmediate: ('a => unit) => unit = "setImmediate"
@scope("jest") @val external advanceTimersByTime: int => unit = "advanceTimersByTime"
@scope("jest") @val external useFakeTimers: unit => unit = "useFakeTimers"
@scope("jest") @val external clearAllTimers: unit => unit = "clearAllTimers"

let flushPromises = fn => {
  open Js.Promise
  make((~resolve, ~reject as _) => setImmediate(value => resolve(. value)))->then_(_ => {
    fn()
    resolve(Js.undefined)
  }, _)->ignore
}

let makePromise = (ms, value) => {
  Js.Promise.make((~resolve, ~reject as _) => {
    let _ = Js.Global.setTimeout(() => resolve(. value), ms)
  })
}
