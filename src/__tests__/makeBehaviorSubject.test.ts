import { describe, it, expect, vi } from 'vitest'

import { forEach } from 'wonka'
import { makeBehaviorSubject } from '..'

describe('makeBehaviorSubject', () => {
  it('*', () => {
    const spy = vi.fn()
    const subject = makeBehaviorSubject('hello')

    forEach(spy)(subject.source)

    subject.next('world')
    subject.next('hello again')

    expect(spy.mock.calls).toEqual([['hello'], ['world'], ['hello again']])
  })
})
