import Service from '@ember/service';
import { service } from '@ember/service';

// import Store from 'ember-data/store';
// TODO: Should we convert this to ember-data Store?
// export default class MountainsStoreService extends Store {

export default class MountainsStoreService extends Service {
  //@ts-expect-error No TS yet
  @service requestManager;
}

// Don't remove this declaration: this is what enables TypeScript to resolve
// this service using `Owner.lookup('service:mountains-store')`, as well
// as to check when you pass the service name as an argument to the decorator,
// like `@service('mountains-store') declare altName: MountainsStoreService;`.
declare module '@ember/service' {
  interface Registry {
    'mountains-store': MountainsStoreService;
  }
}
