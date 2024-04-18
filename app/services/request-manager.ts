//@ts-expect-error TS shenanigans
import RequestManager from '@ember-data/request';
//@ts-expect-error TS shenanigans
import Fetch from '@ember-data/request/fetch';

export default class RequestManagerService extends RequestManager {
  constructor(args?: Record<string | symbol, unknown>) {
    super(args);
    this.use([Fetch]);
  }
}

// Don't remove this declaration: this is what enables TypeScript to resolve
// this service using `Owner.lookup('service:request-manager')`, as well
// as to check when you pass the service name as an argument to the decorator,
// like `@service('request-manager') declare altName: RequestManagerService;`.
declare module '@ember/service' {
  interface Registry {
    'request-manager': RequestManagerService;
  }
}
