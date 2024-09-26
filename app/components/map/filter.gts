import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import type { Pin } from 'the-mountains-are-calling/services/settings';
import Color from 'colorjs.io';

interface MapFilterSignature {
  Args: {
    data: { data: Pin[] };
  };
  Blocks: {
    default: [
      yields: {
        visiblePins: Pin[];
        visiblePolyline: Line[];
        completePolyline: PinLocation[];
        lastKnown: Pin | undefined;
        rememberedPin: Pin | undefined;
      },
    ];
  };
  Element: HTMLDivElement;
}

type PinLocation = (number | undefined)[];

type Line = {
  locations: PinLocation[];
  color: string;
};

const currentColour = new Color('#d946ef');
export const oldColour = currentColour.clone().to('hsl').set({ s: 0 });
const colourRange = currentColour.range(oldColour);

function colorGradient(value: number = 0, min: number, max: number) {
  console.log(value, max);
  return colourRange((value - min) / (max - min)).toString({ format: 'hex' });
}

const CUTOFF = 3 * 60 * 60;

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Filter extends Component<MapFilterSignature> {
  @service declare settings: SettingsService;

  get allPins() {
    return this.args.data.data;
  }

  get lastKnownPin() {
    return this.allPins.at(-1);
  }

  get rememberedPin() {
    const rememberedTimestamp = this.settings.rememberedTimestamp;

    if (rememberedTimestamp === 'last') {
      return this.allPins.at(-1);
    }

    return this.allPins.find((p) => p.timestamp === rememberedTimestamp);
  }

  get pinsTillRemembered() {
    if (!this.rememberedPin) {
      return this.allPins; // This is weird case
    }

    const rememberedPinTimestamp = this.rememberedPin.timestamp;

    return this.allPins.filter(
      (pin) => pin.timestamp <= rememberedPinTimestamp,
    );
  }

  get pinsFromCutoffTillRemembered() {
    if (!this.rememberedPin) {
      return this.pinsTillRemembered; // This is weird case
    }

    const rememberedPinTimestamp = this.rememberedPin.timestamp;

    return this.pinsTillRemembered.filter(
      (pin) => pin.timestamp + CUTOFF >= rememberedPinTimestamp,
    );
  }

  get completePolyline() {
    return this.allPins
      .map((element, index, array) => {
        if (index < array.length - 1) {
          return [element, array[index + 1]];
        }
      })
      .filter((pair) => pair !== undefined);
  }

  get visiblePolyline() {
    const rememberedPinTimestamp = this.rememberedPin?.timestamp ?? 0;

    return this.pinsFromCutoffTillRemembered
      .map((element, index, array) => {
        if (index < array.length - 1) {
          return [element, array[index + 1]];
        }
      })
      .filter((pair) => pair !== undefined)
      .map((elm) => ({
        locations: [
          [elm?.[0]?.latitude, elm?.[0]?.longitude],
          [elm?.[1]?.latitude, elm?.[1]?.longitude],
        ],
        color: colorGradient(
          elm?.[1]?.timestamp,
          rememberedPinTimestamp,
          rememberedPinTimestamp - CUTOFF,
        ),
      }));
  }

  <template>
    {{yield
      (hash
        visiblePins=this.pinsFromCutoffTillRemembered
        visiblePolyline=this.visiblePolyline
        completePolyline=this.completePolyline
        lastKnown=this.lastKnownPin
        rememberedPin=this.rememberedPin
      )
    }}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Filter: typeof Filter;
  }
}
