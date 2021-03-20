module.exports = {
  testEnvironment: 'node',
  verbose: true,
  rootDir: __dirname,
  testMatch: ['<rootDir>/__tests__/*_test.bs.js'],
  testPathIgnorePatterns: [
    'node_modules',
    '<rootDir>/dist',
  ],
  coveragePathIgnorePatterns: ['node_modules', '<rootDir>/__tests__'],
  restoreMocks: true,
}
