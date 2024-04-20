import { helper } from '@ember/component/helper';

export default helper(function timestampToTime(
  positional: [number] /*, named*/,
) {
  return new Date(positional[0] * 1000).toLocaleTimeString();
});
