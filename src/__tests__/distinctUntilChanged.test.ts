import { describe, it, expect, vi } from 'vitest'

import { distinctUntilChanged, makeBehaviorSubject } from '..'
import { forEach, pipe, fromArray } from 'wonka'

describe('distinctUntilChanged', () => {
  it('*', () => {
    const spy = vi.fn()

    pipe(
      fromArray([1, 1, 2, 2, 2, 3, 3, 3, 4, 5, 5, 1]),
      distinctUntilChanged((x, y) => x === y),
      forEach(spy),
    )

    expect(spy.mock.calls).toEqual([[1], [2], [3], [4], [5], [1]])
  })

  it('*', () => {
    const spy = vi.fn()
    const subject = makeBehaviorSubject(1)

    pipe(
      subject.source,
      distinctUntilChanged((x, y) => x === y),
      forEach(spy),
    )

    subject.next(1)
    subject.next(2)
    subject.next(3)
    subject.next(3)
    subject.next(4)
    subject.next(4)
    subject.next(5)
    subject.next(1)

    expect(spy.mock.calls).toEqual([[1], [2], [3], [4], [5], [1]])
  })
})
