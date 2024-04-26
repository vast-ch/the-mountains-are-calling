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
  // ===== .dateFrom =====
  @trackedInLocalStorage({
    keyName: 'dateFrom',
    defaultValue: dayjs().startOf('day').toISOString(),
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
    defaultValue: dayjs().add(1, 'day').startOf('day').toISOString(),
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
