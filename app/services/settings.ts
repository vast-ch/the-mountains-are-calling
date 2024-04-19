import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import type { FormResultData } from '@frontile/forms';
import * as dayjs from 'dayjs';

export default class SettingsService extends Service {
  @tracked deviceId = 'location';
  @tracked date = dayjs().startOf('day');
  @tracked highlightedTimestamp: number | undefined;

  @action onChange(data: FormResultData) {
    this.date = dayjs(data['date'] as string);
    this.deviceId = data['deviceId'] as string;
  }

  get dateString() {
    return this.date.format('YYYY-MM-DD');
  }

  @action
  updateHighlightedTimestamp(timestamp: number) {
    this.highlightedTimestamp = timestamp;
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
