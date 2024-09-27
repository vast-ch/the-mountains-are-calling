import Component from '@glimmer/component';
import type { Pin } from 'the-mountains-are-calling/services/settings';
//@ts-ignore No TS
import { divIcon } from 'ember-leaflet/helpers/div-icon';
import { service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import accuracyToColour from 'the-mountains-are-calling/helpers/accuracy-to-colour';

function accuracyIcon(pin: Pin) {
  return divIcon([], {
    html: `<svg viewBox="0 0 15 15" version="1.1" id="circle" xmlns="http://www.w3.org/2000/svg">
  <path d="M14,7.5c0,3.5899-2.9101,6.5-6.5,6.5S1,11.0899,1,7.5S3.9101,1,7.5,1S14,3.9101,14,7.5z" fill="${accuracyToColour(
    pin.accuracy,
  )}"/>
</svg>`,
    iconSize: [16, 16],
    iconAnchor: [8, 8],
  });
}

interface standardPinSignature {
  Args: {
    pin: Pin | undefined;
    layers: any;
  };
  Element: HTMLDivElement;
}

export default class standardPin extends Component<standardPinSignature> {
  @service declare settings: SettingsService;

  @action
  updateQueryParams(pin: Pin) {
    this.settings.rememberedTimestamp = pin.timestamp;
  }

  <template>
    {{#let this.args.pin as |pin|}}
      {{#if pin}}
        <@layers.marker
          @onClick={{fn this.updateQueryParams pin}}
          @lat={{pin.latitude}}
          @lng={{pin.longitude}}
          @icon={{accuracyIcon pin}}
        />
      {{/if}}
    {{/let}}
  </template>
}
