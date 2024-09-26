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
        pins: Pin[];
        polyline: Location[];
        lastKnown: Pin | undefined;
        rememberedPin: Pin | undefined;
      },
    ];
  };
  Element: HTMLDivElement;
}

type Location = (number[] | undefined)[] | undefined;

const currentColour = new Color('#d946ef');
const oldColour = currentColour.clone().to('hsl').set({ s: 0 });
const colourRange = currentColour.range(oldColour);

function colorGradient(value: number, min: number, max: number): string {
  console.log(value, max);
  return colourRange((value - min) / (max - min)).toString({ format: 'hex' });
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Filter extends Component<MapFilterSignature> {
  @service declare settings: SettingsService;

  get pins(): Pin[] {
    // const dayStart = this.settings.dateFrom.valueOf() / 1000;
    // const dayEnd = this.settings.dateTo.valueOf() / 1000;

    // TODO: make it so it's not .data.data
    return this.args.data.data;

    // TODO: why filter here when Firebase can filter data?
    // return this.args.data.data.filter((elm) => {
    //   return elm.timestamp > dayStart && elm.timestamp < dayEnd;
    // });
  }

  get polyline() {
    const BEFORE = 3 * 60 * 60;
    const rememberedPinTimestamp = this.settings.rememberedPin;

    return this.pins
      .filter(
        (pin) =>
          pin.timestamp <= rememberedPinTimestamp &&
          pin.timestamp + BEFORE >= rememberedPinTimestamp,
      )
      .map((element, index, array) => {
        if (index < array.length - 1) {
          return [element, array[index + 1]];
        }
      })
      .filter((pair) => pair !== undefined)
      .map((elm) => ({
        locations: [
          [elm[0].latitude, elm[0].longitude],
          [elm[1].latitude, elm[1].longitude],
        ],
        color: colorGradient(
          elm[1].timestamp,
          rememberedPinTimestamp,
          rememberedPinTimestamp - BEFORE,
        ),
      }));
  }

  get lastKnown() {
    return this.pins[this.pins.length - 1];
  }

  get rememberedPin() {
    const rememberedPinTimestamp = this.settings.rememberedPin;

    return (
      this.pins.find((p) => p.timestamp === rememberedPinTimestamp) ||
      this.pins.at(-1)
    );
  }

  <template>
    {{yield
      (hash
        pins=this.pins
        polyline=this.polyline
        lastKnown=this.lastKnown
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
