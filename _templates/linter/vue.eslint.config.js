/**
 * Vue + TypeScript ESLint (LSP + external formatter)
 *
 * Requires:
 *  - eslint
 *  - typescript
 *  - vue-eslint-parser
 *  - eslint-plugin-vue
 *  - @typescript-eslint/parser
 *  - @typescript-eslint/eslint-plugin
 *  - eslint-plugin-import
 *  - eslint-import-resolver-alias
 *  - eslint-config-prettier
 */

const vueParser = require("vue-eslint-parser");
const tsParser = require("@typescript-eslint/parser");
const tseslint = require("@typescript-eslint/eslint-plugin");
const vuePlugin = require("eslint-plugin-vue");
const importPlugin = require("eslint-plugin-import");
const prettierConfig = require("eslint-config-prettier");

module.exports = [
  {
    ignores: ["dist", "node_modules", "build", ".output", "coverage"],
  },
  {
    files: ["**/*.{vue,ts,tsx,js,jsx}"],
    languageOptions: {
      parser: vueParser,
      parserOptions: {
        parser: tsParser,
        ecmaVersion: "latest",
        sourceType: "module",
        extraFileExtensions: [".vue"],
      },
    },
    plugins: {
      "@typescript-eslint": tseslint,
      vue: vuePlugin,
      import: importPlugin,
    },
    settings: {
      "import/resolver": {
        alias: {
          map: [["@", "./src"]],
          extensions: [".ts", ".tsx", ".js", ".jsx", ".json", ".vue"],
        },
      },
    },
    rules: {
      ...tseslint.configs.recommended.rules,
      ...vuePlugin.configs["flat/recommended"].rules,

      "import/no-unresolved": "error",

      "@typescript-eslint/no-unused-vars": [
        "warn",
        { argsIgnorePattern: "^_" },
      ],
    },
  },

  prettierConfig,
];
