import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';

export default class IndexController extends Controller {
  queryParams = [
    {
      dateFrom: { type: 'string' as const },
      dateTo: { type: 'string' as const },
      rememberedPin: { type: 'string' as const },
      zoom: { type: 'string' as const },
    },
  ];

  @tracked dateFrom = '';
  @tracked dateTo = '';
  @tracked rememberedPin = '';
  @tracked zoom = '';
}
