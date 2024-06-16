import Component from '@glimmer/component';
import { resourceFactory, cell, resource } from 'ember-resources';
import dayjs from 'dayjs';
import { hash } from '@ember/helper';

interface Signature {
  Args: {
    period: number;
    fn: () => {};
  };
  Blocks: {
    default: [
      {
        progress: number;
      },
    ];
  };
  Element: HTMLDivElement;
}

const Clock = function (period: number, callback: () => {}) {
  return resource(({ on }) => {
    let lastTickTime = cell(dayjs());
    let diff = period;

    console.log({ period }, { callback });

    const timer = setInterval(() => {
      diff = dayjs().diff(lastTickTime.current, 'seconds');

      if (diff >= period) {
        lastTickTime.current = dayjs();
        callback();
      }
    }, 1000);

    on.cleanup(() => {
      clearInterval(timer);
    });

    console.log({ diff });

    return diff;
  });
};

resourceFactory(Clock);

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Interval extends Component<Signature> {
  <template>
    {{yield (hash progress=(Clock this.args.period this.args.fn))}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Interval: typeof Interval;
  }
}
