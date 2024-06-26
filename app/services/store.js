// eslint-disable-next-line ember/use-ember-data-rfc-395-imports
import Store from 'ember-data/store';
import { inject as service } from '@ember/service';

export default class StoreService extends Store {
  //@ts-expect-error No TS yet
  @service requestManager;
}

// Don't remove this declaration: this is what enables TypeScript to resolve
// this service using `Owner.lookup('service:mountains-store')`, as well
// as to check when you pass the service name as an argument to the decorator,
// like `@service('mountains-store') declare altName: StoreService;`.
declare module '@ember/service' {
  interface Registry {
    store: StoreService;
  }
}
