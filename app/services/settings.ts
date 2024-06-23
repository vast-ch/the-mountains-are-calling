import Service from '@ember/service';
import { action } from '@ember/object';
import * as dayjs from 'dayjs';
//@ts-expect-error No TS yet
import { trackedInLocalStorage } from 'ember-tracked-local-storage';
import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import { tracked } from '@glimmer/tracking';

// TODO: Can this be inferred from the model?
export interface Pin {
  latitude: number;
  longitude: number;
  timestamp: number;
  accuracy: number;
  altitude: number;
  battery: number;
  velocity: number;
  fixAge: number;
}

interface Dict<T> {
  [key: string]: T;
}

const QP_FORMAT = 'YYYY-MM-DD';

export default class SettingsService extends Service {
  @service declare router: RouterService;

  get qp(): Dict<unknown> {
    return this.router.currentRoute?.queryParams || {};
  }

  get dateToday() {
    return dayjs().format(QP_FORMAT);
  }

  get dateTomorrow() {
    return dayjs().add(1, 'day').format(QP_FORMAT);
  }

  // ===== .rememberedPin =====
  // This one exists to persist selected pin to QP
  get rememberedPin(): number | undefined | 'last' {
    if (!this.qp['rememberedPin']) {
      return undefined;
    }
    if (this.qp['rememberedPin'] === 'last') {
      return 'last';
    }

    return Number.parseFloat(this.qp['rememberedPin'] as string);
  }
  set rememberedPin(newPin: number | undefined | 'last') {
    this.router.replaceWith({
      queryParams: { rememberedPin: newPin ? newPin.toString() : undefined },
    });
  }

  // ===== .highlightedPin =====
  // This one exists to highlight given pin directly in the app
  @tracked highlightedPin: number | undefined = undefined;

  // ===== .toggleAutoFastForward =====
  @action toggleAutoFastForward(newValue: boolean) {
    this.rememberedPin = newValue ? 'last' : undefined;
    this.dateFrom = this.dateToday;
    this.dateTo = this.dateTomorrow;
  }

  // ===== .autoFastForward =====
  get autoFastForward(): boolean {
    return this.rememberedPin == 'last';
  }

  // ===== .dateFrom =====
  get dateFrom(): dayjs.Dayjs {
    return dayjs((this.qp['dateFrom'] as string) || this.dateToday);
  }
  set dateFrom(newDate: string | dayjs.Dayjs) {
    let dateFrom;

    if (typeof newDate === 'string') {
      // dayjs gives _current_ date _only_ for `dayjs(undefined)`, no `dayjs(null)`
      dateFrom = dayjs(newDate || undefined);
    } else {
      dateFrom = newDate;
    }

    this.router.transitionTo({
      queryParams: { dateFrom: dateFrom.startOf('day').format(QP_FORMAT) },
    });
  }

  get dateFromShort() {
    return this.dateFrom.format('YYYY-MM-DD');
  }

  // ===== .dateTo =====
  get dateTo(): dayjs.Dayjs {
    return dayjs((this.qp['dateTo'] as string) || this.dateTomorrow);
  }
  set dateTo(newDate: string | dayjs.Dayjs) {
    let dateTo;

    if (typeof newDate === 'string') {
      // dayjs gives _current_ date _only_ for `dayjs(undefined)`, no `dayjs(null)`
      dateTo = dayjs(newDate || undefined);
    } else {
      dateTo = newDate;
    }

    this.router.transitionTo({
      queryParams: { dateTo: dateTo.startOf('day').format(QP_FORMAT) },
    });
  }

  get dateToShort() {
    return this.dateTo.format('YYYY-MM-DD');
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
