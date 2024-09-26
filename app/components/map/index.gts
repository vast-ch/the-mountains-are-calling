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
import rememberedPin from './pin/highlighted';
import standardPin from './pin/standard';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

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

  lat = 46.686;
  lng = 7.858;

  @action
  zoomend(event: any) {
    this.settings.zoom = event.target.getZoom() as number;
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
          {{#if filtered.rememberedPin}}
            <LeafletMap
              @onZoomend={{this.zoomend}}
              class='w-full min-h-64 flex-1 border-2'
              @lat={{filtered.rememberedPin.latitude}}
              @lng={{filtered.rememberedPin.longitude}}
              @zoom={{this.settings.zoom}}
              as |layers|
            >
              <layers.tile
                @url='https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg'
              />

              {{#each filtered.polyline as |line index|}}
                {{!-- {{log '---' filtered.recentPast}} --}}
                {{!-- {{log filtered.polyline}} --}}
                {{log line}}
                <layers.polyline
                  @locations={{line.locations}}
                  @color={{line.color}}
                  {{!-- @color={{colorGradient index filtered.locations.length}} --}}
                  {{! @color='#d946ef' }}
                  @weight='5'
                />
              {{/each}}

              {{#each filtered.pins as |pin index|}}
                <standardPin @pin={{pin}} @layers={{layers}} />
              {{/each}}

              <rememberedPin
                @pin={{filtered.rememberedPin}}
                @layers={{layers}}
              />

            </LeafletMap>
          {{/if}}
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
