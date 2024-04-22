import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import * as dayjs from 'dayjs';

interface MapFilterSignature {
  Args: {
    data: any[];
  };
  Blocks: {
    default: [yields: { points: any; locations: any; lastKnown: any }];
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Filter extends Component<MapFilterSignature> {
  @service declare settings: SettingsService;

  get points() {
    const dayStart = this.settings.date.valueOf() / 1000;
    const dayEnd = this.settings.date.endOf('day').valueOf() / 1000;

    return Object.values(this.args.data).filter((elm) => {
      return elm.timestamp > dayStart && elm.timestamp < dayEnd;
    });
  }

  get locations() {
    return this.points.map((point) => [point.latitude, point.longitude]);
  }

  get lastKnown() {
    return this.points[this.points.length - 1];
  }

  <template>
    {{yield
      (hash
        points=this.points locations=this.locations lastKnown=this.lastKnown
      )
    }}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Filter: typeof Filter;
  }
}
