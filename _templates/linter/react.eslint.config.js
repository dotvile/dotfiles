/**
 * React + TypeScript ESLint (LSP + external formatter)
 *
 * Requires:
 *  - eslint
 *  - typescript
 *  - @typescript-eslint/parser
 *  - @typescript-eslint/eslint-plugin
 *  - eslint-plugin-react
 *  - eslint-plugin-react-hooks
 *  - eslint-plugin-import
 *  - eslint-import-resolver-alias
 *  - eslint-config-prettier
 */

const tsParser = require("@typescript-eslint/parser");
const tseslint = require("@typescript-eslint/eslint-plugin");
const reactPlugin = require("eslint-plugin-react");
const reactHooks = require("eslint-plugin-react-hooks");
const importPlugin = require("eslint-plugin-import");
const prettierConfig = require("eslint-config-prettier");

module.exports = [
  {
    ignores: ["dist", "node_modules", "build", ".output", "coverage"],
  },
  {
    files: ["**/*.{ts,tsx,js,jsx}"],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        ecmaFeatures: { jsx: true },
      },
    },
    plugins: {
      "@typescript-eslint": tseslint,
      react: reactPlugin,
      "react-hooks": reactHooks,
      import: importPlugin,
    },
    settings: {
      react: { version: "detect" },
      "import/resolver": {
        alias: {
          map: [["@", "./src"]],
          extensions: [".ts", ".tsx", ".js", ".jsx", ".json"],
        },
      },
    },
    rules: {
      ...tseslint.configs.recommended.rules,
      ...reactPlugin.configs.recommended.rules,
      ...reactHooks.configs.recommended.rules,

      "react/react-in-jsx-scope": "off",
      "import/no-unresolved": "error",

      "@typescript-eslint/no-unused-vars": [
        "warn",
        { argsIgnorePattern: "^_" },
      ],
    },
  },

  prettierConfig,
];
