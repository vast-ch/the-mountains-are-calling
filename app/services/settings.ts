import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import * as dayjs from 'dayjs';
//@ts-expect-error No TS yet
import { trackedInLocalStorage } from 'ember-tracked-local-storage';

export interface Point {
  latitude: number;
  longitude: number;
  timestamp: number;
  accuracy: number;
}

export default class SettingsService extends Service {
  // ===== .date =====
  @trackedInLocalStorage({
    keyName: 'date',
    defaultValue: dayjs().startOf('day').toISOString(),
  })
  declare _date: string;

  get date(): dayjs.Dayjs {
    return dayjs(this._date);
  }
  set date(newDate: string | dayjs.Dayjs) {
    if (typeof newDate === 'string') {
      // dayjs gives _current_ date _only_ for `dayjs(undefined)`, no `dayjs(null)`
      this._date = dayjs(newDate || undefined)
        .startOf('day')
        .toISOString();
    } else {
      this._date = newDate.startOf('day').toISOString();
    }
  }

  get dateShort() {
    return dayjs(this.date).format('YYYY-MM-DD');
  }

  @action
  addDays(amount: number) {
    this.date = this.date.add(amount, 'days');
  }

  // ===== .deviceId =====
  @trackedInLocalStorage({ keyName: 'deviceId', defaultValue: 'demo' })
  declare _deviceId: string;
  get deviceId() {
    return this._deviceId;
  }
  set deviceId(newDeviceId: string) {
    this._deviceId = newDeviceId;
  }

  // ===== .highlightedPoint =====
  @tracked highlightedPoint: Point | undefined;

  // ===== .isAccuracyVisible =====
  @trackedInLocalStorage({ keyName: 'isAccuracyVisible', defaultValue: true })
  declare _isAccuracyVisible: string;
  get isAccuracyVisible() {
    return this._isAccuracyVisible === 'true';
  }
  set isAccuracyVisible(newValue: boolean) {
    this._isAccuracyVisible = Boolean(newValue).toString();
  }

  // ===== .hasOneDaySelection =====
  @trackedInLocalStorage({ keyName: 'hasOneDaySelection', defaultValue: true })
  declare _hasOneDaySelection: string;
  get hasOneDaySelection() {
    return this._hasOneDaySelection === 'true';
  }
  set hasOneDaySelection(newValue: boolean) {
    this._hasOneDaySelection = Boolean(newValue).toString();
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
