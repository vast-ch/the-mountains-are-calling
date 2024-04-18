import Component from '@glimmer/component';
import { service } from '@ember/service';
// import { query } from '@ember-data/rest/request';
import { Request } from '@warp-drive/ember';
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import MapForm from './form';
import { action } from '@ember/object';
import type { FormResultData } from '@frontile/forms';
import type { EmptyObject } from '@glimmer/component/-private/component';
import { cached, tracked } from '@glimmer/tracking';
import { getPromiseState } from '@warp-drive/ember';
import { getRequestState } from '@warp-drive/ember';
import { trackedFunction } from 'reactiveweb/function';
import { resourceFactory, resource, use } from 'ember-resources';

export default class Map extends Component {
  @service mountainsStore;

  @tracked startDate = new Date(new Date().getTime() - 60 * 60 * 24 * 7 * 1000);
  @tracked endDate = new Date();

  @action onChange(
    data: FormResultData,
    eventType: 'input' | 'submit',
    event: Event | SubmitEvent,
  ) {
    console.log({ data }, { eventType }, { event });
  }

  lng = 7.8536;
  lat = 46.68027;
  zoom = 15;

  // promise = this.mountainsStore.requestManager.request({
  //   url: `https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app/location.json`,
  // });

  // @cached
  // get data() {
  //   const startAt = this.startDate.getTime() / 1000;
  //   const endAt = this.endDate.getTime() / 1000;

  //   console.log(this.promise);
  //   const state = getPromiseState(this.promise);
  //   if (state.isPending) {
  //     return [];
  //   }
  //   if (state.isError) {
  //     return [];
  //   }
  //   return state.result;
  // }

  data = trackedFunction(this, async () => {
    const startAt = this.startDate.getTime() / 1000;
    const endAt = this.endDate.getTime() / 1000;
    const promise = this.mountainsStore.requestManager.request({
      url: `https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app/location.json`,
    });
    const data = await promise;
    return data.content;
  });

  <template>
    <MapForm
      @startDate={{this.startDate}}
      @endDate={{this.endDate}}
      @onChange={{this.onChange}}
    />

    {{log this.data.value}}

    {{!-- <Request @request={{this.data}}>
      <:loading>
        Loading
      </:loading>

      <:content as |result|>
        {{log result}}

        <LeafletMap
          @lat={{this.lat}}
          @lng={{this.lng}}
          @zoom={{this.zoom}}
          class='w-full h-64'
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

    </Request> --}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Map: typeof Map;
  }
}
