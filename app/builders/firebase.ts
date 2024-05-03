import type { Dayjs } from 'dayjs';

export function firebaseQuery(
  deviceUrl: string = '',
  dateFrom: Dayjs,
  dateTo: Dayjs,
  counter: number,
) {
  const cacheOptions = {};
  const headers = new Headers();
  const queryParams = new URLSearchParams({
    orderBy: '"timestamp"',
    startAt: dateFrom.unix().toString(),
    endAt: dateTo.unix().toString(),
    counter: counter.toString(),
  }).toString();

  return {
    url: `${deviceUrl}?${queryParams}`, // TODO: ugly hack for now
    method: 'GET',
    headers,
    cacheOptions,
    op: 'firebase',
  };
}
