const esbuild = require('esbuild')
const { babel } = require('./plugins/esbuild-babel-plugin')
const { curryGuaranteePlugin } = require('./plugins/babel-curry-guarantee-plugin')

const handleError = () => process.exit(1)
const build = (outfile, options) => {
  return esbuild
    .build({
      entryPoints: ['src/WonkaExtras.bs.js'],
      bundle: true,
      format: 'cjs',
      outfile: `dist/${outfile}`,
      plugins: [
        babel({
          config: {
            babelrc: false,
            exclude: 'node_modules/**',
            plugins: [
              [
                'module-resolver',
                {
                  root: ['./src'],
                  alias: {
                    'wonka/src/Wonka.bs.js': 'wonka',
                  },
                },
              ],
              curryGuaranteePlugin,
              'closure-elimination',
              'minify-dead-code-elimination',
            ],
          },
        }),
      ],
      minify: false,
      external: ['wonka'],
      logLevel: 'info',
      ...options,
    })
    .catch(handleError)
}

build('index.js')
build('index.min.js', { minify: true })
build('index.mjs', { format: 'esm' })
