const path = require('path');

const { frontile, safelist } = require('@frontile/theme/plugin');

const appRoot = path.join(__dirname, '../');
const libraries = [
  /* someLibraryName */
];

const libraryPaths = libraries.map((name) =>
  path.dirname(require.resolve(name)),
);

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    `${appRoot}/app/**/*.{js,ts,hbs,gjs,gts,html}`,
    ...libraryPaths.map(
      (libraryPath) => `${libraryPath}/**/*.{js,ts,hbs,gjs,gts,html}`,
    ),
    './node_modules/@frontile/theme/dist/**/*.{js,ts}',
  ],
  theme: {
    extend: {},
  },
  plugins: [frontile()],
  safelist: [
    ...safelist,

    // Power Select
    { pattern: /^ember-power-select/ },
  ],
};
