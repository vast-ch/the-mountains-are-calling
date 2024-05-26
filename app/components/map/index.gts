import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import Filter from './filter';
import Color from 'colorjs.io';
import L, { LatLngBounds, Point } from 'leaflet';
import { isEmpty } from 'ember-truth-helpers';
import { formatNumber, t } from 'ember-intl';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import timestampToHuman from 'the-mountains-are-calling/helpers/timestamp-to-human';
//@ts-ignore HeroIcon nope
import HeroIcon from 'ember-heroicons/components/hero-icon';
import DateSelector from './date-selector';
import PointSelector from './point-selector';
//@ts-ignore No TS
import { icon } from 'ember-leaflet/helpers/icon';
import relativeTime from 'dayjs/plugin/relativeTime';
import dayjs from 'dayjs';
import Loader from '../loader';
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

function colorGradient(index: number, max: number): string {
  return newOldColor(index / max).toString({ format: 'hex' });
}

function getBounds(locations: [[]]): LatLngBounds {
  let ret = L.polyline(locations).getBounds();
  return ret;
}

const pinHighlighted = icon([], {
  iconUrl: '/images/pin-highlighted.svg',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  tooltipAnchor: [16, -28],
  shadowSize: [41, 41],
});

const pinStandard = icon([], {
  iconUrl: '/images/pin-standard.svg',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  tooltipAnchor: [16, -28],
  shadowSize: [41, 41],
});

export default class Map extends Component<Signature> {
  @service mountainsStore: any;
  @service declare settings: SettingsService;

  autoPanPadding = new Point(50, 50);

  pickHighlightedPin(
    points: Pin[],
    highlightedPinTimestamp: number,
  ): Pin | undefined {
    return points.find((p) => p.timestamp === highlightedPinTimestamp);
  }

  get highlightedPinRelative() {
    if (!this.settings.highlightedPin) {
      return undefined;
    }
    return dayjs(this.settings.highlightedPin.timestamp * 1000).fromNow();
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
            <div class='flex flex-col'>
              <HeroIcon @icon='inbox' class='h-16' />
              {{t 'error.no-data-to-display'}}
            </div>
          </div>
        {{else}}
          <LeafletMap
            @bounds={{getBounds filtered.locations}}
            class='w-full min-h-64 flex-1'
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

            {{#let
              (this.pickHighlightedPin
                filtered.pins this.settings.highlightedPin
              )
              as |pin|
            }}
              {{#if pin}}
                <layers.marker
                  @lat={{pin.latitude}}
                  @lng={{pin.longitude}}
                  @icon={{pinHighlighted}}
                  as |marker|
                >
                  <marker.popup
                    @popupOpen='true'
                    @autoPanPadding={{this.autoPanPadding}}
                  >
                    <ul>
                      <li>{{timestampToHuman pin.timestamp}}</li>
                      {{#if this.highlightedPinRelative}}
                        <li>{{this.highlightedPinRelative}}</li>
                      {{/if}}
                      <li>{{t
                          'map.accuracy'
                          value=(formatNumber
                            pin.accuracy
                            style='unit'
                            unit='meter'
                            maximumFractionDigits=0
                          )
                        }}
                      </li>
                    </ul>
                  </marker.popup>
                </layers.marker>

                {{#if this.settings.isAccuracyVisible}}
                  <layers.circle
                    @lat={{pin.latitude}}
                    @lng={{pin.longitude}}
                    @radius={{pin.accuracy}}
                  />
                {{/if}}
              {{/if}}
            {{/let}}

            {{#each filtered.pins as |pin index|}}
              <layers.marker
                @lat={{pin.latitude}}
                @lng={{pin.longitude}}
                @icon={{pinStandard}}
              />
            {{/each}}

          </LeafletMap>
        {{/if}}
      </Filter>
    </Loader>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Map: typeof Map;
  }
}
