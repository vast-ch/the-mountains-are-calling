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

const QP_FORMAT = 'YYYY-MM-DD';

export default class SettingsService extends Service {
  @service declare router: RouterService;

  get defaultQp() {
    return {
      dateFrom: this.dateToday,
      dateTo: this.dateTomorrow,
      rememberedTimestamp: 'last',
      zoom: '15',
      latitude: '46.686',
      longitude: '7.858',
    };
  }

  get qp() {
    const r =
      (this.router.currentRoute?.queryParams as typeof this.defaultQp) || {};
    const d = this.defaultQp;

    const ret = {
      dateFrom: r['dateFrom'] ?? d.dateFrom,
      dateTo: r['dateTo'] ?? d.dateTo,
      rememberedTimestamp: r['rememberedTimestamp'] ?? d.rememberedTimestamp,
      zoom: r['zoom'] ?? d.zoom,
      latitude: r['latitude'] ?? d.latitude,
      longitude: r['longitude'] ?? d.longitude,
    };
    return ret;
  }

  get dateToday() {
    return dayjs().format(QP_FORMAT);
  }

  get dateTomorrow() {
    return dayjs().add(1, 'day').format(QP_FORMAT);
  }

  // ===== .latitude =====
  get latitude(): number {
    return Number.parseFloat(this.qp['latitude']);
  }
  set latitude(newLatitude: number | undefined) {
    this.router.replaceWith({
      queryParams: {
        latitude: newLatitude,
      },
    });
  }

  // ===== .longitude =====
  get longitude(): number {
    return Number.parseFloat(this.qp['longitude']);
  }
  set longitude(newLongitude: number | undefined) {
    this.router.replaceWith({
      queryParams: {
        longitude: newLongitude,
      },
    });
  }

  // ===== .zoom =====
  get zoom(): number {
    return Number.parseInt(this.qp['zoom']);
  }
  set zoom(newZoom: number | undefined) {
    this.router.replaceWith({
      queryParams: {
        zoom: newZoom,
      },
    });
  }

  // ===== .rememberedTimestamp =====
  get rememberedTimestamp(): number | 'last' {
    if (this.qp['rememberedTimestamp'] === 'last') {
      return 'last';
    }

    return Number.parseInt(this.qp['rememberedTimestamp']);
  }
  set rememberedTimestamp(newPin: number | undefined) {
    this.router.replaceWith({
      queryParams: { rememberedTimestamp: newPin ? newPin.toString() : newPin },
    });
  }

  // ===== .toggleAutoFastForward =====
  @action toggleAutoFastForward() {
    this.rememberedTimestamp = undefined;
    this.dateFrom = undefined;
    this.dateTo = undefined;
    this.zoom = undefined;
    this.latitude = undefined;
    this.longitude = undefined;
  }

  // ===== .isAutoFastForward =====
  get isAutoFastForward(): boolean {
    return this.rememberedTimestamp == 'last';
  }

  // ===== .dateFrom =====
  get dateFrom(): dayjs.Dayjs {
    return dayjs(this.qp['dateFrom']);
  }
  set dateFrom(newDate: string | dayjs.Dayjs | undefined) {
    let dateFrom;

    if (newDate !== undefined) {
      if (typeof newDate === 'string') {
        dateFrom = dayjs(newDate);
      } else {
        dateFrom = newDate;
      }
      dateFrom = dateFrom.startOf('day').format(QP_FORMAT);
    }

    this.router.transitionTo({
      queryParams: { dateFrom },
    });
  }

  get dateFromShort() {
    return this.dateFrom.format('YYYY-MM-DD');
  }

  // ===== .dateTo =====
  get dateTo(): dayjs.Dayjs {
    return dayjs(this.qp['dateTo']);
  }
  set dateTo(newDate: string | dayjs.Dayjs | undefined) {
    let dateTo;

    if (newDate !== undefined) {
      if (typeof newDate === 'string') {
        dateTo = dayjs(newDate);
      } else {
        dateTo = newDate;
      }
      dateTo = dateTo.startOf('day').format(QP_FORMAT);
    }

    this.router.transitionTo({
      queryParams: { dateTo },
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
    defaultValue: '600',
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

  // ===== .lastKnownEmoji =====
  @trackedInLocalStorage({
    keyName: 'lastKnownEmoji',
    defaultValue: '🦄',
  })
  declare _lastKnownEmoji: string;
  get lastKnownEmoji() {
    return this._lastKnownEmoji;
  }
  set lastKnownEmoji(newValue: string) {
    this._lastKnownEmoji = newValue;
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
