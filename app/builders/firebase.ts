import { buildBaseURL } from '@ember-data/request-utils';
import type { Dayjs } from 'dayjs';

export function firebaseQuery(
  deviceId: string = '',
  dateFrom: Dayjs,
  dateTo: Dayjs,
) {
  const cacheOptions = {};
  const urlOptions = {
    host: 'https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app',
    namespace: '',
    resourcePath: deviceId,
  };

  const url = buildBaseURL(urlOptions);
  const headers = new Headers();
  headers.append('Accept', 'application/json;charset=utf-8');
  const queryParams = new URLSearchParams({
    orderBy: '"timestamp"',
    startAt: dateFrom.unix().toString(),
    endAt: dateTo.unix().toString(),
  }).toString();

  return {
    url: `${url}.json?${queryParams}`, // TODO: ugly hack for now
    method: 'GET',
    headers,
    cacheOptions,
    op: 'firebase',
  };
}
