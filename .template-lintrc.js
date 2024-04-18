'use strict';

module.exports = {
  extends: ['recommended', 'plugin:yml/standard'],
  rules: {
    'no-bare-strings': true,
    'yml/file-extension': 'error',
    'yml/key-name-casing': [
      'error',
      {
        camelCase: false,
        'kebab-case': true,
        PascalCase: false,
        SCREAMING_SNAKE_CASE: false,
        snake_case: false,
        ignores: ['^[a-z0-9\\.-]+$'],
      },
    ],
    'yml/no-multiple-empty-lines': 'error',
    'yml/sort-keys': 'error',
  },
};
