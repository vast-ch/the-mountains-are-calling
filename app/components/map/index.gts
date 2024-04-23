import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import { Request } from '@warp-drive/ember';
// @ts-expect-error No TS stuff yet
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import MapForm from './form';
import Filter from './filter';
import Color from 'colorjs.io';
import L, { LatLngBounds, Point } from 'leaflet';
import { isEmpty } from 'ember-truth-helpers';
import { t } from 'ember-intl';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import timestampToHuman from 'the-mountains-are-calling/helpers/timestamp-to-human';
import { hash } from '@ember/helper';
import { firebaseQuery } from 'the-mountains-are-calling/builders/firebase';

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

function bounds(locations: [[]]): LatLngBounds {
  let ret = L.polyline(locations).getBounds();
  return ret;
}

export default class Map extends Component<Signature> {
  @service mountainsStore: any;
  @service declare settings: SettingsService;

  autoPanPadding = new Point(50, 50);

  get request(): number[] {
    return this.mountainsStore.requestManager.request(
      firebaseQuery(this.settings.deviceId),
    );
  }

  <template>
    <Request @request={{this.request}}>
      <:loading>
        Loading...
      </:loading>

      <:content as |result|>
        <Filter @data={{result}} as |filtered|>
          <MapForm @data={{filtered.points}} />

          {{#if (isEmpty filtered.points)}}
            {{t 'error.no-data-to-display'}}
          {{else}}
            <LeafletMap
              @bounds={{bounds filtered.locations}}
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

              {{#let this.settings.highlightedPoint as |point|}}
                {{#if point}}
                  <layers.marker
                    @lat={{point.latitude}}
                    @lng={{point.longitude}}
                    as |marker|
                  >
                    <marker.popup
                      @popupOpen='true'
                      @autoPanPadding={{this.autoPanPadding}}
                    >
                      {{timestampToHuman point.timestamp}}
                    </marker.popup>
                  </layers.marker>
                {{/if}}
              {{/let}}

              {{#each filtered.points as |point index|}}
                <layers.marker
                  @lat={{point.latitude}}
                  @lng={{point.longitude}}
                />
                {{#if this.settings.isAccuracyVisible}}
                  <layers.circle
                    @lat={{point.latitude}}
                    @lng={{point.longitude}}
                    @radius={{point.accuracy}}
                    @color={{colorGradient index filtered.points.length}}
                    @opacity='0.1'
                    @fillOpacity='0.1'
                  />
                {{/if}}
              {{/each}}

            </LeafletMap>
          {{/if}}
        </Filter>
      </:content>

    </Request>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Map: typeof Map;
  }
}
