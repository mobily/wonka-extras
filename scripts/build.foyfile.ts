import { task, desc, option, setGlobalOptions } from 'foy'

setGlobalOptions({
  strict: true,
  logCommand: false,
  loading: false,
})

type Options = {
  readonly runTests: boolean
}

desc('Build dist')
option('-t, --run-tests', 'run tests')
task<Options>('dist', async ctx => {
  await ctx.exec(['pnpm clean', 'node esbuild.config.js'])

  await ctx.exec(['pnpm generate tsc', 'pnpm generate flow'])

  if (ctx.options.runTests) {
    await ctx.exec('pnpm test')
  }
})
