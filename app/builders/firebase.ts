import { buildBaseURL } from '@ember-data/request-utils';

export function firebaseQuery(deviceId: string = '') {
  const cacheOptions = {};
  const urlOptions = {
    host: 'https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app',
    namespace: '',
    resourcePath: deviceId,
  };

  const url = buildBaseURL(urlOptions);
  const headers = new Headers();
  headers.append('Accept', 'application/json;charset=utf-8');

  return {
    url: `${url}.json`, // TODO: ugly hack for now
    method: 'GET',
    headers,
    cacheOptions,
    op: 'firebase',
  };
}
