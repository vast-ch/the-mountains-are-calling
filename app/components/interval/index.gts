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
    console.log('Creating clock resource', { period }, { callback });

    let lastTickTime = cell(dayjs());
    let diff = period;

    const timer = setInterval(() => {
      console.log('Clock is ticking');
      diff = dayjs().diff(lastTickTime.current, 'seconds');

      if (diff >= period) {
        console.log('Clock is calling callback');
        lastTickTime.current = dayjs();
        callback();
      }
    }, 1000);

    on.cleanup(() => {
      console.log('Clearing up interval');
      clearInterval(timer);
    });

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
