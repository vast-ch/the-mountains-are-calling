import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import type { FormResultData } from '@frontile/forms';
import * as dayjs from 'dayjs';

export default class SettingsService extends Service {
  @tracked deviceId = 'demo';
  @tracked startDate = dayjs().subtract(1, 'week').startOf('day').valueOf();
  @tracked endDate = dayjs().endOf('day').valueOf();

  @action onChange(data: FormResultData) {
    this.startDate = dayjs(data['startDate'] as string)
      .startOf('day')
      .valueOf();
    this.endDate = dayjs(data['endDate'] as string)
      .endOf('day')
      .valueOf();
    this.deviceId = data['deviceId'] as string;
  }
}

// Don't remove this declaration: this is what enables TypeScript to resolve
// this service using `Owner.lookup('service:settings')`, as well
// as to check when you pass the service name as an argument to the decorator,
// like `@service('settings') declare altName: SettingsService;`.
declare module '@ember/service' {
  interface Registry {
    settings: SettingsService;
  }
}
