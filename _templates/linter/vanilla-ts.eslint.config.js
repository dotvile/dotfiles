/**
 * Vanilla TypeScript ESLint (LSP + external formatter)
 *
 * Requires when running eslint:
 *  - eslint
 *  - typescript
 *  - @typescript-eslint/parser
 *  - @typescript-eslint/eslint-plugin
 *  - eslint-plugin-import
 *  - eslint-import-resolver-alias
 *  - eslint-config-prettier
 */

const tsParser = require("@typescript-eslint/parser");
const tseslint = require("@typescript-eslint/eslint-plugin");
const importPlugin = require("eslint-plugin-import");
const prettierConfig = require("eslint-config-prettier");

module.exports = [
  {
    ignores: ["dist", "node_modules", "build", ".output", "coverage"],
  },
  {
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
      },
    },
    plugins: {
      "@typescript-eslint": tseslint,
      import: importPlugin,
    },
    settings: {
      "import/resolver": {
        alias: {
          map: [["@", "./src"]],
          extensions: [".ts", ".tsx", ".js", ".json"],
        },
      },
    },
    rules: {
      ...tseslint.configs.recommended.rules,
      "import/no-unresolved": "error",
      "@typescript-eslint/no-unused-vars": [
        "warn",
        { argsIgnorePattern: "^_" },
      ],
    },
  },

  // Disable rules that conflict with Prettier
  prettierConfig,
];
