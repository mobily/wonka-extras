module.exports = {
  testEnvironment: 'node',
  verbose: true,
  rootDir: __dirname,
  testMatch: ['<rootDir>/__tests__/*_test.bs.js'],
  testPathIgnorePatterns: ['node_modules', '<rootDir>/dist'],
  coveragePathIgnorePatterns: ['node_modules', '<rootDir>/__tests__'],
  moduleNameMapper: {
    '^bs-platform/lib/es6/(.*).js$': '<rootDir>/node_modules/bs-platform/lib/js/$1.js',
    '^wonka/src/Wonka.bs.js$': '<rootDir>/node_modules/wonka/dist/wonka.js',
  },
  restoreMocks: true,
  transform: {
    '^.+\\.bs.js$': 'babel-jest',
  },
  transformIgnorePatterns: ['node_modules/(?!(reason-test-framework|bs-platform|wonka)/.*)'],
}
