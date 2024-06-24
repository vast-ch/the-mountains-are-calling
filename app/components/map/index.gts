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
import HighlightedPin from './highlighted-pin';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

// TODO: Is there a better place?
dayjs.extend(relativeTime);

interface Signature {
  Args: {};
  Blocks: {};
  Element: HTMLDivElement;
}

let oldColor = new Color('#dc2626');
let newOldColor = oldColor.range('#84cc16');

function colorGradient(index: number, max: number): string {
  return newOldColor(index / max).toString({ format: 'hex' });
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

  lat = 46.686;
  lng = 7.858;

  @action
  zoomend(event: any) {
    this.settings.zoom = event.target.getZoom();
  }

  <template>
    <Loader as |l|>
      <Filter @data={{l.result}} as |filtered|>
        <div class='flex flex-col gap-2 pb-2'>
          <DateSelector />
          <PointSelector @data={{filtered.pins}} />
        </div>

        {{#if (isEmpty filtered.pins)}}
          <div class='w-full py-32 flex justify-center items-center'>
            <div class='flex flex-col items-center'>
              <Tray @size='32' />
              {{t 'error.no-data-to-display'}}
            </div>
          </div>
        {{else}}
          <LeafletMap
            @onZoomend={{this.zoomend}}
            class='w-full min-h-64 flex-1 border-2'
            @lat={{this.lat}}
            @lng={{this.lng}}
            @zoom={{this.settings.zoom}}
            as |layers|
          >
            <layers.tile
              @url='https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg'
            />

            {{#each filtered.locations as |line index|}}
              <layers.polyline
                @locations={{line}}
                @color={{colorGradient index filtered.locations.length}}
                @weight='10'
              />
            {{/each}}

            {{#each filtered.pins as |pin index|}}
              <layers.marker
                @lat={{pin.latitude}}
                @lng={{pin.longitude}}
                @icon={{pinStandard}}
              />
            {{/each}}

            <HighlightedPin @pins={{filtered.pins}} @layers={{layers}} />

          </LeafletMap>
        {{/if}}

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
