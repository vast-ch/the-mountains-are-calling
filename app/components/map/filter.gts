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
        pinsBeforeRemembered: Pin[];
        pinsAfterRemembered: Pin[];
        polylineBeforeRemembered: Line[];
        polylineAfterRemembered: PinLocation[];
        lastKnown: Pin | undefined;
        rememberedPin: Pin | undefined;
      },
    ];
  };
  Element: HTMLDivElement;
}

type PinLocation = (number | undefined)[][];

type Line = {
  locations: PinLocation;
  color: string;
};

const currentColour = new Color('#d946ef');
const oldColour = currentColour.clone().to('hsl').set({ s: 0 });
const colourRange = currentColour.range(oldColour);

function colorGradient(value: number = 0, min: number, max: number) {
  return colourRange((value - min) / (max - min)).toString({ format: 'hex' });
}

const CUTOFF = 2 * 60 * 60;

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

  get pinsBeforeRemembered() {
    if (!this.rememberedPin) {
      return this.allPins; // This is weird case
    }

    const rememberedPinTimestamp = this.rememberedPin.timestamp;

    return this.allPins.filter(
      (pin) => pin.timestamp <= rememberedPinTimestamp,
    );
  }

  get pinsAfterRemembered() {
    if (!this.rememberedPin) {
      return this.allPins; // This is weird case
    }

    const rememberedPinTimestamp = this.rememberedPin.timestamp;

    return this.allPins.filter(
      (pin) => pin.timestamp >= rememberedPinTimestamp,
    );
  }

  get pinsBeforeRememberedCutoff() {
    if (!this.rememberedPin) {
      return this.pinsBeforeRemembered; // This is weird case
    }

    const rememberedPinTimestamp = this.rememberedPin.timestamp;

    return this.pinsBeforeRemembered.filter(
      (pin) => pin.timestamp + CUTOFF > rememberedPinTimestamp,
    );
  }

  get pinsAfterRememberedCutoff() {
    if (!this.rememberedPin) {
      return this.pinsBeforeRemembered; // This is weird case
    }

    const rememberedPinTimestamp = this.rememberedPin.timestamp;

    return this.pinsAfterRemembered.filter(
      (pin) => pin.timestamp < rememberedPinTimestamp + CUTOFF,
    );
  }

  get polylineBeforeRemembered() {
    const rememberedPinTimestamp = this.rememberedPin?.timestamp ?? 0;

    return this.pinsBeforeRememberedCutoff
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

  get polylineAfterRemembered() {
    return this.pinsAfterRememberedCutoff
      .map((element, index, array) => {
        if (index < array.length - 1) {
          return [element, array[index + 1]];
        }
      })
      .filter((pair) => pair !== undefined)
      .map((elm) => [
        [elm?.[0]?.latitude, elm?.[0]?.longitude],
        [elm?.[1]?.latitude, elm?.[1]?.longitude],
      ]);
  }

  <template>
    {{yield
      (hash
        pinsBeforeRemembered=this.pinsBeforeRememberedCutoff
        pinsAfterRemembered=this.pinsAfterRememberedCutoff
        polylineBeforeRemembered=this.polylineBeforeRemembered
        polylineAfterRemembered=this.polylineAfterRemembered
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
