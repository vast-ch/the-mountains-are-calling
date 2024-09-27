import { helper } from '@ember/component/helper';
import dayjs from 'dayjs';

export default function timestampToTime(timestamp: number) {
  return dayjs(timestamp * 1000).format('HH:mm');
}
