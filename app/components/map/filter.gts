import Component from '@glimmer/component';
import { hash } from '@ember/helper';

interface MapFilterSignature {
  Args: {
    data: any[];
    startDate: Date;
    endDate: Date;
  };
  Blocks: {
    default: [points: any];
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Filter extends Component<MapFilterSignature> {
  get points() {
    const startDate = this.args.startDate.getTime() / 1000;
    const endDate = this.args.endDate.getTime() / 1000;

    return Object.values(this.args.data).filter((elm) => {
      return elm.timestamp > startDate && elm.timestamp < endDate;
    });
  }

  get locations() {
    return this.points.map((point) => [point.latitude, point.longitude]);
  }

  <template>
    {{yield (hash points=this.points locations=this.locations)}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Filter: typeof Filter;
  }
}
