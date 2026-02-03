/**
 * Vanilla JavaScript ESLint (LSP + external formatter)
 *
 * Requires:
 *  - eslint
 *  - eslint-config-prettier
 */

const prettierConfig = require("eslint-config-prettier");

module.exports = [
  {
    ignores: ["dist", "node_modules", "build", ".output", "coverage"],
  },
  {
    files: ["**/*.{js,mjs,cjs,jsx}"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
    },
    rules: {
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
    },
  },

  prettierConfig,
];
