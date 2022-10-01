export const makePromise = (ms: number) => <T>(value: T): Promise<T> => {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(value)
    }, ms)
  })
}

export const flushPromises = (fn: () => void) => {
  return new Promise(process.nextTick).then(() => {
    fn()
    return Promise.resolve()
  })
}
