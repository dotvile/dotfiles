/**
 * Node.js + TypeScript ESLint (LSP + external formatter)
 *
 * Requires:
 *  - eslint
 *  - typescript
 *  - @typescript-eslint/parser
 *  - @typescript-eslint/eslint-plugin
 *  - eslint-plugin-import
 *  - eslint-import-resolver-alias
 *  - eslint-plugin-n
 *  - eslint-config-prettier
 */

const tsParser = require("@typescript-eslint/parser");
const tseslint = require("@typescript-eslint/eslint-plugin");
const importPlugin = require("eslint-plugin-import");
const nodePlugin = require("eslint-plugin-n");
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

    env: {
      node: true,
    },

    plugins: {
      "@typescript-eslint": tseslint,
      import: importPlugin,
      n: nodePlugin,
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
      ...nodePlugin.configs["recommended-module"].rules,

      "import/no-unresolved": "error",
      "n/no-process-exit": "off",

      "@typescript-eslint/no-unused-vars": [
        "warn",
        { argsIgnorePattern: "^_" },
      ],
    },
  },

  prettierConfig,
];
