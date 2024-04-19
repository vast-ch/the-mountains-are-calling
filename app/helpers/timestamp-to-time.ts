import { helper } from '@ember/component/helper';

export default helper(function timestampToTime(
  positional: [number] /*, named*/,
) {
  console.log(positional[0]);
  return new Date(positional[0] * 1000).toLocaleTimeString();
});
