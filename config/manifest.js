'use strict';

module.exports = function (/* environment, appConfig */) {
  // See https://zonkyio.github.io/ember-web-app for a list of
  // supported properties

  return {
    name: 'The Mountains Are Calling',
    short_name: 'TMAC',
    description: 'Simple location sharing, excluding the Big Brother',
    start_url: '/',
    scope: '/',
    display: 'standalone',
    background_color: '#fefae0',
    theme_color: '#606c38',
    icons: [
      {
        src: '/assets/icons/appicon-32.png',
        sizes: '32x32',
        targets: ['favicon'],
      },
      ...[192, 280, 512].map((size) => ({
        src: `/assets/icons/appicon-${size}.png`,
        sizes: `${size}x${size}`,
      })),
    ],
    ms: {
      tileColor: '#606c38',
    },
  };
};
