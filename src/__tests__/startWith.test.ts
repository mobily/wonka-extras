import { describe, it, expect, vi, beforeEach } from 'vitest'

import { startWith } from '..'
import { forEach, pipe, fromArray, fromPromise, merge, map } from 'wonka'
import { flushPromises, makePromise } from './utils'

describe('startWith', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  it('*', () => {
    const spy = vi.fn()

    pipe(fromArray([1, 2, 3]), startWith(0), forEach(spy))

    expect(spy).toBeCalledTimes(4)
    expect(spy.mock.calls).toEqual([[0], [1], [2], [3]])
  })

  it('*', async () => {
    const spy = vi.fn()
    const promise100 = makePromise(100)
    const promise200 = makePromise(200)

    pipe(
      merge([fromPromise(promise100('healthy')), fromPromise(promise200('safe'))]),
      map(value => `stay ${value}`),
      startWith('stay calm'),
      forEach(spy),
    )

    vi.advanceTimersByTime(200)

    await flushPromises(() => {
      expect(spy.mock.calls).toEqual([['stay calm'], ['stay healthy'], ['stay safe']])
    })
  })
})
