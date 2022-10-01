import { describe, it, expect, vi } from 'vitest'

import { pairwise, makeBehaviorSubject } from '..'
import { forEach, pipe, fromArray } from 'wonka'

describe('pairwise', () => {
  it('*', () => {
    const spy = vi.fn()

    pipe(fromArray([1, 2, 3, 4, 5]), pairwise, forEach(spy))

    expect(spy.mock.calls).toEqual([[[1, 2]], [[2, 3]], [[3, 4]], [[4, 5]]])
  })

  it('*', () => {
    const spy = vi.fn()
    const subject = makeBehaviorSubject(1)

    pipe(subject.source, pairwise, forEach(spy))

    subject.next(2)
    subject.next(3)

    expect(spy.mock.calls).toEqual([[[1, 2]], [[2, 3]]])
  })
})
