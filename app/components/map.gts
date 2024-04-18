import Component from '@glimmer/component';
import { service } from '@ember/service';
// import { query } from '@ember-data/rest/request';
import { Request } from '@warp-drive/ember';
import LeafletMap from 'ember-leaflet/components/leaflet-map';

export default class Map extends Component {
  @service mountainsStore;

  lng = 7.8536;
  lat = 46.68027;
  zoom = 15;

  get data() {
    const promise = this.mountainsStore.requestManager.request({
      url: 'https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app/location.json',
    });
    return promise;
  }

  <template>
    <Request @request={{this.data}}>
      <:loading>
        Loading
      </:loading>

      <:content as |result|>
        {{log result}}

        <LeafletMap
          @lat={{this.lat}}
          @lng={{this.lng}}
          @zoom={{this.zoom}}
          as |layers|
        >
          <layers.tile
            @url='https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
          />

          {{#each-in result as |key point|}}
            <layers.marker
              @lat={{point.latitude}}
              @lng={{point.longitude}}
              as |marker|
            >
              <marker.popup>
                {{point.timestamp}}
              </marker.popup>
            </layers.marker>
          {{/each-in}}

        </LeafletMap>

      </:content>

    </Request>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Map: typeof Map;
  }
}