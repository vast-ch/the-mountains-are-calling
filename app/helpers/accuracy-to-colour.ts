import Color from 'colorjs.io';

const MAX_INACCURACY = 1500;
const goodPrecisionColour = new Color('#84cc16');
const badPrecisionColour = new Color('#991b1b');
const colourRange = goodPrecisionColour.range(badPrecisionColour);

export default function accuracyToColour(accuracy: number) {
  return colourRange(
    Math.min(accuracy, MAX_INACCURACY) / MAX_INACCURACY,
  ).toString({
    format: 'hex',
  });
}
