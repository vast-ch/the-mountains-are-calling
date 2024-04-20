import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import type { FormResultData } from '@frontile/forms';
import * as dayjs from 'dayjs';
//@ts-expect-error No TS yet
import { trackedInLocalStorage } from 'ember-tracked-local-storage';

export default class SettingsService extends Service {
  @trackedInLocalStorage({ defaultValue: 'demo' }) declare deviceId: string;
  @trackedInLocalStorage({ defaultValue: dayjs().startOf('day').toString() })
  declare date: string;

  @tracked highlightedTimestamp: number | undefined;

  @action onChange(data: FormResultData) {
    this.date = dayjs(data['date'] as string)
      .startOf('day')
      .toISOString();
    this.deviceId = data['deviceId'] as string;
  }

  get dateShort() {
    return dayjs(this.date).format('YYYY-MM-DD');
  }

  get dateDayJs() {
    return dayjs(this.date);
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
