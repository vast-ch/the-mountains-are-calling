import Component from '@glimmer/component';
import type { Pin } from 'the-mountains-are-calling/services/settings';
//@ts-ignore No TS
import { icon } from 'ember-leaflet/helpers/icon';
import { service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import MapPinPopup from './popup';

const pinRemembered = icon([], {
  iconUrl: '/images/pin-remembered.svg',
  iconSize: [24, 24],
  iconAnchor: [12, 24],
  popupAnchor: [0, -20],
  class: 'z-[900]',
});

interface rememberedPinSignature {
  Args: {
    pin: Pin | undefined;
    layers: any;
  };
  Element: HTMLDivElement;
}

export default class rememberedPin extends Component<rememberedPinSignature> {
  @service declare settings: SettingsService;

  <template>
    {{#if @pin}}
      <@layers.marker
        @lat={{@pin.latitude}}
        @lng={{@pin.longitude}}
        @icon={{pinRemembered}}
        @zIndexOffset={{1001}}
        as |marker|
      >
        <MapPinPopup @marker={{marker}} @pin={{@pin}} />
      </@layers.marker>

      {{#if this.settings.isAccuracyVisible}}
        <@layers.circle
          @lat={{@pin.latitude}}
          @lng={{@pin.longitude}}
          @radius={{@pin.accuracy}}
        />
      {{/if}}
    {{/if}}
  </template>
}
