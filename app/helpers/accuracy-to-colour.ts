import { helper } from '@ember/component/helper';
import Color from 'colorjs.io';

const MAX_INACCURACY = 1500;

const INACCURACY_COLOURS = [
  '#4ade80', // green-400
  '#a3e635', // lime-400
  '#facc15', // yellow-400
  '#fde047', // yellow-300
  '#f97316', // orange-500
  '#fb923c', // orange-400
  '#f87171', // red-400
  '#ef4444', // red-500
  '#dc2626', // red-600
  '#b91c1c', // red-700
];

export default function accuracyToColour(accuracy: number) {
  const cappedAccuracy = Math.min(accuracy, MAX_INACCURACY);

  const index = Math.floor(
    (cappedAccuracy / MAX_INACCURACY) * (INACCURACY_COLOURS.length - 1),
  );

  return INACCURACY_COLOURS[index] || INACCURACY_COLOURS.at(-1);
}
