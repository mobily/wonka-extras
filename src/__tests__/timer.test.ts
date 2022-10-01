import { describe, it, expect, vi, beforeEach } from 'vitest'

import { timer } from '..'
import { forEach, pipe } from 'wonka'

describe('timer', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  it('*', () => {
    const spy = vi.fn()

    pipe(timer(2000), forEach(spy))

    vi.advanceTimersByTime(100)
    vi.runAllTimers()

    expect(spy).toHaveBeenCalledTimes(1)
    expect(spy).toHaveBeenLastCalledWith(0)
  })
})
