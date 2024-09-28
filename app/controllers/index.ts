import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';

export default class IndexController extends Controller {
  queryParams = [
    {
      dateFilter: { type: 'string' as const },
      rememberedTimestamp: { type: 'string' as const },
      zoom: { type: 'string' as const },
      latitude: { type: 'string' as const },
      longitude: { type: 'string' as const },
    },
  ];

  dateFilter: string | undefined;
  rememberedTimestamp: string | undefined;
  zoom: string | undefined;
  latitude: string | undefined;
  longitude: string | undefined;
}
