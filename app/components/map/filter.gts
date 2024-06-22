import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import type { Pin } from 'the-mountains-are-calling/services/settings';

interface MapFilterSignature {
  Args: {
    data: Pin[];
  };
  Blocks: {
    default: [yields: { pins: any; locations: any; lastKnown: any }];
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Filter extends Component<MapFilterSignature> {
  @service declare settings: SettingsService;

  get pins() {
    // const dayStart = this.settings.dateFrom.valueOf() / 1000;
    // const dayEnd = this.settings.dateTo.valueOf() / 1000;

    // TODO: make it so it's not .data.data
    return this.args.data.data;

    // TODO: why filter here when Firebase can filter data?
    // return this.args.data.data.filter((elm) => {
    //   return elm.timestamp > dayStart && elm.timestamp < dayEnd;
    // });
  }

  get locations(): ((number[] | undefined)[] | undefined)[] {
    return this.pins
      .map((elm) => [elm.latitude, elm.longitude])
      .map((element, index, array) => {
        if (index < array.length - 1) {
          return [element, array[index + 1]];
        }
      })
      .filter((pair) => pair !== undefined);
  }

  get lastKnown() {
    return this.pins[this.pins.length - 1];
  }

  <template>
    {{yield
      (hash pins=this.pins locations=this.locations lastKnown=this.lastKnown)
    }}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Filter: typeof Filter;
  }
}
