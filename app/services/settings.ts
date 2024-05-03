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

const DEMO_DATE = '2024-04-18';

export default class SettingsService extends Service {
  // ===== .dateFrom =====
  @trackedInLocalStorage({
    keyName: 'dateFrom',
    defaultValue: dayjs(DEMO_DATE).startOf('day').toISOString(),
  })
  declare _dateFrom: string;

  get dateFrom(): dayjs.Dayjs {
    return dayjs(this._dateFrom);
  }
  set dateFrom(newDate: string | dayjs.Dayjs) {
    if (typeof newDate === 'string') {
      // dayjs gives _current_ date _only_ for `dayjs(undefined)`, no `dayjs(null)`
      this._dateFrom = dayjs(newDate || undefined)
        .startOf('day')
        .toISOString();
    } else {
      this._dateFrom = newDate.startOf('day').toISOString();
    }
  }

  get dateFromShort() {
    return dayjs(this.dateFrom).format('YYYY-MM-DD');
  }

  // ===== .dateTo =====
  @trackedInLocalStorage({
    keyName: 'dateTo',
    defaultValue: dayjs(DEMO_DATE).add(1, 'day').startOf('day').toISOString(),
  })
  declare _dateTo: string;

  get dateTo(): dayjs.Dayjs {
    return dayjs(this._dateTo);
  }
  set dateTo(newDate: string | dayjs.Dayjs) {
    if (typeof newDate === 'string') {
      // dayjs gives _current_ date _only_ for `dayjs(undefined)`, no `dayjs(null)`
      this._dateTo = dayjs(newDate || undefined)
        .startOf('day')
        .toISOString();
    } else {
      this._dateTo = newDate.startOf('day').toISOString();
    }
  }

  get dateToShort() {
    return dayjs(this.dateTo).format('YYYY-MM-DD');
  }

  // ===== .date ======
  // Getter is shorthand for dateFrom
  // Setter will set dateFrom to current value and dateTo to +1 day
  get date() {
    return this.dateFrom;
  }
  set date(newDate: string | dayjs.Dayjs) {
    const value = dayjs(newDate);
    this.dateFrom = value;
    this.dateTo = value.add(1, 'day').startOf('day');
  }

  // ===== .addDays() =====
  @action
  addDays(amount: number) {
    this.dateFrom = this.dateFrom.add(amount, 'days');
    this.dateTo = this.dateTo.add(amount, 'days');
  }

  // ===== .providerId =====
  @trackedInLocalStorage({
    keyName: 'providerId',
    defaultValue: 'firebase-realtime-database',
  })
  declare _providerId: string;
  get providerId(): string {
    return this._providerId;
  }
  set provider(newProviderId: string[]) {
    this._providerId = newProviderId[0] || 'firebase-realtime-database';
  }

  // ===== .deviceUrl =====
  @trackedInLocalStorage({
    keyName: 'deviceUrl',
    defaultValue:
      'https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app/demo.json',
  })
  declare _deviceUrl: string;
  get deviceUrl() {
    return this._deviceUrl;
  }
  set deviceUrl(newDeviceUrl: string) {
    this._deviceUrl = newDeviceUrl;
  }

  // ===== .refreshInterval =====
  @trackedInLocalStorage({
    keyName: 'refreshInterval',
    defaultValue: '0',
  })
  declare _refreshInterval: string;
  get refreshInterval() {
    return Number.parseInt(this._refreshInterval);
  }
  set refreshInterval(newrefreshInterval: number) {
    this._refreshInterval = newrefreshInterval.toString();
  }
  get refreshIntervalMs() {
    return this.refreshInterval * 1000;
  }

  // ===== .highlightedPoint =====
  @tracked highlightedPoint: Point | undefined;

  // ===== .isAccuracyVisible =====
  @trackedInLocalStorage({ keyName: 'isAccuracyVisible', defaultValue: 'true' })
  declare _isAccuracyVisible: string;
  get isAccuracyVisible() {
    return this._isAccuracyVisible === 'true';
  }
  set isAccuracyVisible(newValue: boolean) {
    this._isAccuracyVisible = Boolean(newValue).toString();
  }

  // ===== .hasOneDaySelection =====
  @trackedInLocalStorage({
    keyName: 'hasOneDaySelection',
    defaultValue: 'true',
  })
  declare _hasOneDaySelection: string;
  get hasOneDaySelection() {
    return this._hasOneDaySelection === 'true';
  }
  set hasOneDaySelection(newValue: boolean) {
    // When we're going to "one day seleciton" we need to sync from&to dates
    if (newValue === true) {
      this.date = this.dateFrom;
    }
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
