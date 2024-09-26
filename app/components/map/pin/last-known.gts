import Component from '@glimmer/component';
import type { Pin } from 'the-mountains-are-calling/services/settings';
//@ts-ignore No TS
import { icon } from 'ember-leaflet/helpers/icon';

const pinLastKnown = icon([], {
  iconUrl: '/images/pin-last-known.svg',
  iconSize: [24, 24],
  iconAnchor: [12, 24],
});

interface lastKnownPinSignature {
  Args: {
    pin: Pin | undefined;
    layers: any;
  };
  Element: HTMLDivElement;
}

export default class lastKnownPin extends Component<lastKnownPinSignature> {
  <template>
    {{#let this.args.pin as |pin|}}
      {{#if pin}}
        <@layers.marker
          class='z-100'
          @lat={{pin.latitude}}
          @lng={{pin.longitude}}
          @icon={{pinLastKnown}}
        />
      {{/if}}
    {{/let}}
  </template>
}
