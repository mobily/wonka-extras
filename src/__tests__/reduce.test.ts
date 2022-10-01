import { describe, it, expect, vi } from 'vitest'

import { reduce } from '..'
import { forEach, pipe, fromArray } from 'wonka'

describe('reduce', () => {
  it('*', () => {
    const spy = vi.fn()

    pipe(
      fromArray([1, 2, 3, 4, 5]),
      reduce((acc, value) => {
        return acc.concat([value * 10])
      }, [] as number[]),
      forEach(spy),
    )

    expect(spy).toHaveBeenCalledTimes(1)
    expect(spy).toHaveBeenLastCalledWith([10, 20, 30, 40, 50])
  })
})
