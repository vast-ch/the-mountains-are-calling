import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import { Request } from '@warp-drive/ember';
// @ts-expect-error No TS stuff yet
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import MapForm from './form';
import Filter from './filter';
import Color from 'colorjs.io';
import L, { LatLngBounds } from 'leaflet';
import type { FormSignature } from '@frontile/forms';
import { isEmpty } from 'ember-truth-helpers';
import { t } from 'ember-intl';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { eq } from 'ember-truth-helpers';
import timestampToHuman from 'the-mountains-are-calling/helpers/timestamp-to-human';

interface Signature {
  Args: {};
  Blocks: {};
  Element: HTMLDivElement;
}

let oldColor = new Color('#5e1600');
let newOldColor = oldColor.range('#8bbe1b');

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

  get request() {
    return this.mountainsStore.requestManager.request({
      url: `https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app/${this.settings.deviceId}.json`,
    });
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
                @url='https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
              />

              <layers.polyline @locations={{filtered.locations}} />

              {{#each filtered.points as |point index|}}
                <layers.circle
                  @lat={{point.latitude}}
                  @lng={{point.longitude}}
                  @radius={{point.accuracy}}
                  @color={{colorGradient index filtered.points.length}}
                  @opacity='0.1'
                  @fillOpacity='0.1'
                  as |circle|
                >
                  <circle.popup>
                    {{timestampToHuman point.timestamp}}
                  </circle.popup>
                </layers.circle>

                {{#if (eq point.timestamp this.settings.highlightedTimestamp)}}
                  <layers.marker
                    @lat={{point.latitude}}
                    @lng={{point.longitude}}
                    as |marker|
                  >
                    <marker.popup @popupOpen='true'>
                      {{timestampToHuman point.timestamp}}
                    </marker.popup>
                  </layers.marker>
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
