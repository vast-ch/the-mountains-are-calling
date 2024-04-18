import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import { Request } from '@warp-drive/ember';
// @ts-expect-error No TS stuff yet
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import MapForm from './form';
import { action } from '@ember/object';
import type { FormResultData } from '@frontile/forms';
import { tracked } from '@glimmer/tracking';
import Filter from './filter';
import Color from 'colorjs.io';
import L, { LatLngBounds } from 'leaflet';

interface Signature {
  Args: {};
  Blocks: {};
  Element: HTMLDivElement;
}

function timestampToHuman(timestamp: number): string {
  return new Date(timestamp).toLocaleString();
}

let oldColor = new Color('#696969');
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

  @tracked startDate = new Date(new Date().getTime() - 60 * 60 * 24 * 7 * 1000);
  @tracked endDate = new Date();

  @action onChange(data: FormResultData) {
    this.startDate = new Date(data['startDate'] as string);
    this.endDate = new Date(data['endDate'] as string);
  }

  lng = 7.8536;
  lat = 46.68027;
  zoom = 15;

  get request() {
    return this.mountainsStore.requestManager.request({
      url: `https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app/location.json`,
    });
  }

  <template>
    <MapForm
      @startDate={{this.startDate}}
      @endDate={{this.endDate}}
      @onChange={{this.onChange}}
    />

    <Request @request={{this.request}}>
      <:loading>
        Loading...
      </:loading>

      <:content as |result|>
        <Filter
          @data={{result}}
          @startDate={{this.startDate}}
          @endDate={{this.endDate}}
          as |filtered|
        >
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
                as |circle|
              >
                <circle.popup>
                  {{timestampToHuman point.timestamp}}
                </circle.popup>
              </layers.circle>

            {{/each}}

          </LeafletMap>
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
