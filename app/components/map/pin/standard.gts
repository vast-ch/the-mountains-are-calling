import Component from '@glimmer/component';
import type { Pin } from 'the-mountains-are-calling/services/settings';
import { formatNumber, t } from 'ember-intl';
//@ts-ignore No TS
import { divIcon } from 'ember-leaflet/helpers/div-icon';
import { service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import Color from 'colorjs.io';
import { action } from '@ember/object';
import { fn } from '@ember/helper';

function accuracyIcon(pin: Pin) {
  return divIcon([], {
    html: `<svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 viewBox="0 0 490 490" xml:space="preserve">
<polygon points="386.813,0 245,141.812 103.188,0 0,103.188 141.813,245 0,386.812 103.187,489.999 245,348.187 386.813,490
	490,386.812 348.187,244.999 490,103.187 " fill="${colorGradient(
    pin.accuracy,
    MAX_INACCURACY,
  )}"/>
</svg>`,
    iconSize: [24, 24],
    iconAnchor: [12, 12],
  });
}

const MAX_INACCURACY = 1500;
const goodPrecisionColour = new Color('#0ea5e9');
const badPrecisionColour = goodPrecisionColour.clone().to('hsl').set({ s: 0 });
const colourRange = goodPrecisionColour.range(badPrecisionColour);

function colorGradient(value: number, max: number): string {
  return colourRange(Math.min(value, max) / max).toString({ format: 'hex' });
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
  updaterememberedPin(timestamp: number) {
    this.settings.rememberedPin = timestamp;
  }

  <template>
    {{#let this.args.pin as |pin|}}
      {{#if pin}}
        <@layers.marker
          @onClick={{fn this.updaterememberedPin pin.timestamp}}
          @lat={{pin.latitude}}
          @lng={{pin.longitude}}
          @icon={{accuracyIcon pin}}
        />
      {{/if}}
    {{/let}}
  </template>
}
