import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import Filter from './filter';
import Color from 'colorjs.io';
import L, { LatLngBounds } from 'leaflet';
import { isEmpty } from 'ember-truth-helpers';
import { t } from 'ember-intl';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import Interval from '../interval';
import Tray from 'ember-phosphor-icons/components/ph-tray';
import DateSelector from './date-selector';
import PointSelector from './point-selector';
//@ts-ignore No TS
import { icon } from 'ember-leaflet/helpers/icon';
import relativeTime from 'dayjs/plugin/relativeTime';
import dayjs from 'dayjs';
import Loader from '../loader';
import rememberedPin from './pin/remembered';
import standardPin from './pin/standard';
import lastKnownPin from './pin/last-known';
import grayPin from './pin/gray';
import { action } from '@ember/object';
import type { Pin } from 'the-mountains-are-calling/services/settings';

// TODO: Is there a better place?
dayjs.extend(relativeTime);

interface Signature {
  Args: {};
  Blocks: {};
  Element: HTMLDivElement;
}

let oldColor = new Color('#dc2626');
let newOldColor = oldColor.range('#84cc16');

function colorGradient(value: number, max: number): string {
  return newOldColor(value / max).toString({ format: 'hex' });
}

const pinStandard = icon([], {
  iconUrl: '/images/pin-standard.svg',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  tooltipAnchor: [16, -28],
  shadowSize: [41, 41],
});

export default class Map extends Component<Signature> {
  @service declare settings: SettingsService;

  @action
  zoomend(event: any) {
    this.settings.zoom = event.target.getZoom() as number;
  }

  @action
  moveend(event: any) {
    const center = event.target.getCenter();
    // this.settings.longitude = center.lng;
    // this.settings.latitude = center.lat;
  }

  getLatitude = (lastKnown: Pin | undefined) => {
    return this.settings.latitude ?? lastKnown?.latitude;
  };

  getLongitude = (lastKnown: Pin | undefined) => {
    return this.settings.longitude ?? lastKnown?.longitude;
  };

  <template>
    <Loader as |l|>
      <Filter @data={{l.result}} as |filtered|>

        {{#if (isEmpty filtered.pinsBeforeRemembered)}}
          <div class='w-full py-32 flex justify-center items-center'>
            <div class='flex flex-col items-center'>
              <Tray @size='32' />
              {{t 'error.no-data-to-display'}}
            </div>
          </div>
        {{else}}
          {{#if filtered.rememberedPin}}
            <LeafletMap
              @onZoomend={{this.zoomend}}
              @onMoveend={{this.moveend}}
              class='w-full min-h-64 flex-1 border-2'
              @lat={{this.getLatitude filtered.lastKnown}}
              @lng={{this.getLongitude filtered.lastKnown}}
              @zoom={{this.settings.zoom}}
              as |layers|
            >
              <layers.tile
                @url='https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg'
              />

              <layers.polyline
                @locations={{filtered.polylineAfterRemembered}}
                @color='#aaa'
                @weight={{5}}
                @opacity={{0.75}}
              />

              {{#each filtered.polylineBeforeRemembered as |line index|}}
                <layers.polyline
                  @locations={{line.locations}}
                  @color={{line.color}}
                  @weight='5'
                />
              {{/each}}

              {{#each filtered.pinsBeforeRemembered as |pin index|}}
                <standardPin @pin={{pin}} @layers={{layers}} />
              {{/each}}

              <rememberedPin
                @pin={{filtered.rememberedPin}}
                @layers={{layers}}
              />

              {{#each filtered.pinsAfterRemembered as |pin index|}}
                <grayPin @pin={{pin}} @layers={{layers}} />
              {{/each}}

              <lastKnownPin @pin={{filtered.lastKnown}} @layers={{layers}} />

            </LeafletMap>
          {{/if}}
        {{/if}}

        <div class='flex flex-col gap-2 pt-2'>
          <DateSelector />
          <PointSelector
            @data={{l.result.data}}
            @rememberedPin={{filtered.rememberedPin}}
          />
        </div>

        <Interval
          @period={{this.settings.refreshInterval}}
          @callback={{l.state.refresh}}
          @isRefreshing={{l.state.isRefreshing}}
        />
      </Filter>
    </Loader>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Map: typeof Map;
  }
}
