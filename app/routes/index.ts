import Route from '@ember/routing/route';

export default class IndexRoute extends Route {
  queryParams = {
    dateFrom: {},
    dateTo: {},
    highlightedPin: { replace: true },
  };
}
