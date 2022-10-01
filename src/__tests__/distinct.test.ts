import { describe, it, expect, vi } from 'vitest'

import { distinct, makeBehaviorSubject } from '..'
import { forEach, pipe, fromArray } from 'wonka'

describe('distinct', () => {
  it('*', () => {
    const spy = vi.fn()

    pipe(
      fromArray([1, 2, 3, 4, 5, 1, 2, 3, 4, 5]),
      distinct(value => value),
      forEach(spy),
    )

    expect(spy.mock.calls).toEqual([[1], [2], [3], [4], [5]])
  })

  it('*', () => {
    const spy = vi.fn()
    const subject = makeBehaviorSubject({ index: 1 })

    pipe(
      subject.source,
      distinct(obj => obj.index),
      forEach(spy),
    )

    subject.next({ index: 1 })
    subject.next({ index: 2 })
    subject.next({ index: 3 })
    subject.next({ index: 1 })
    subject.next({ index: 2 })
    subject.next({ index: 3 })
    subject.next({ index: 4 })

    expect(spy.mock.calls).toEqual([[{ index: 1 }], [{ index: 2 }], [{ index: 3 }], [{ index: 4 }]])
  })
})
