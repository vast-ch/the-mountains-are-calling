import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';

export default class IndexController extends Controller {
  queryParams = [
    {
      dateFrom: { type: 'string' as const },
      dateTo: { type: 'string' as const },
      rememberedTimestamp: { type: 'string' as const },
      zoom: { type: 'string' as const },
      latitude: { type: 'string' as const },
      longitude: { type: 'string' as const },
    },
  ];

  dateFrom: string | undefined;
  dateTo: string | undefined;
  rememberedTimestamp: string | undefined;
  zoom: string | undefined;
  latitude: string | undefined;
  longitude: string | undefined;
}
