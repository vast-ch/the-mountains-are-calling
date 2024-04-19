import { helper } from '@ember/component/helper';

export default helper(function timestampToHuman(
  positional: [number] /*, named*/,
) {
  return new Date(positional[0] * 1000).toLocaleString();
});
