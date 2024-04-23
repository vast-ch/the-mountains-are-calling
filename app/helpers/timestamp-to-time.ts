import { helper } from '@ember/component/helper';
import dayjs from 'dayjs';

export default helper(function timestampToTime(
  positional: [number] /*, named*/,
) {
  return dayjs(positional[0] * 1000).format('HH:mm');
});
