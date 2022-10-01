import { describe, it, expect, vi, beforeEach } from 'vitest'

import { forkJoin, makeBehaviorSubject } from '..'
import { forEach, pipe, fromArray, fromPromise, fromValue, mergeMap } from 'wonka'
import { flushPromises, makePromise } from './utils'

describe('forkJoin', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  it('*', async () => {
    const spy = vi.fn()
    const promise200 = makePromise(200)
    const promise500 = makePromise(500)

    pipe(
      forkJoin(
        fromPromise(promise200('hello')),
        fromArray(['x', 'y', 'z']),
        fromPromise(promise500(100)),
        fromValue(200),
      ),
      forEach(spy),
    )

    vi.advanceTimersByTime(500)

    await flushPromises(() => {
      expect(spy).toHaveBeenCalledTimes(1)
      expect(spy).toHaveBeenCalledWith(['hello', 'x', 100, 200])
    })
  })

  it('*', async () => {
    const spy = vi.fn()
    const promise200 = makePromise(200)
    const promise500 = makePromise(500)
    const subject = makeBehaviorSubject(3)

    pipe(
      subject.source,
      mergeMap(value => {
        return forkJoin(fromPromise(promise500(1)), fromPromise(promise200(2)), fromValue(value))
      }),
      forEach(spy),
    )

    subject.next(4)
    subject.next(5)

    vi.advanceTimersByTime(1000)
    vi.runAllTimers()

    await flushPromises(() => {
      expect(spy.mock.calls).toEqual([[[1, 2, 3]], [[1, 2, 4]], [[1, 2, 5]]])
    })
  })
})
