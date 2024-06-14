import RequestManager from '@ember-data/request';
import Fetch from '@ember-data/request/fetch';
import FirebaseHandler from '../handlers/firebase';

export default class RequestManagerService extends RequestManager {
  constructor(args?: Record<string | symbol, unknown>) {
    super(args);
    console.log('there');
    this.use([FirebaseHandler, Fetch]);
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
