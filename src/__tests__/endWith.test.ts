import { describe, it, expect, vi, beforeEach } from 'vitest'

import { endWith } from '..'
import { forEach, pipe, fromArray, fromPromise, merge, map } from 'wonka'
import { makePromise, flushPromises } from './utils'

describe('endWith', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  it('*', () => {
    const spy = vi.fn()

    pipe(fromArray([1, 2, 3]), endWith(0), forEach(spy))

    expect(spy.mock.calls).toEqual([[1], [2], [3], [0]])
  })

  it('*', async () => {
    const spy = vi.fn()
    const promise100 = makePromise(100)
    const promise200 = makePromise(200)

    pipe(
      merge([fromPromise(promise200('healthy')), fromPromise(promise100('safe'))]),
      map(value => `stay ${value}`),
      endWith('stay calm'),
      forEach(spy),
    )

    vi.advanceTimersByTime(200)

    await flushPromises(() => {
      expect(spy.mock.calls).toEqual([['stay safe'], ['stay healthy'], ['stay calm']])
    })
  })
})
