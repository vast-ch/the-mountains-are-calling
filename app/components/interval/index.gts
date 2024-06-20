import Component from '@glimmer/component';
import { resourceFactory, cell, resource } from 'ember-resources';
import dayjs from 'dayjs';
import { hash } from '@ember/helper';
import { ProgressBar } from '@frontile/status';

interface Signature {
  Args: {
    period: number;
    isRefreshing: boolean;
    callback: () => {};
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
    let diff = cell(0);

    const timer = setInterval(() => {
      // console.log('tick',dayjs().diff(lastTickTime.current, 'seconds'));
      diff.current = dayjs().diff(lastTickTime.current, 'seconds');

      if (diff.current > period) {
        lastTickTime.current = dayjs();
        // console.log('callback');
        callback();
      }
    }, 1000);

    on.cleanup(() => {
      // console.log('clear');
      clearInterval(timer);
    });

    return diff;
  });
};

resourceFactory(Clock);

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Interval extends Component<Signature> {
  <template>
    {{#let (Clock this.args.period this.args.callback) as |c|}}
      {{!-- {{log c}} --}}
      <ProgressBar
        @size='xs'
        @maxValue={{this.args.period}}
        @progress={{c}}
        @isIndeterminate={{this.args.isRefreshing}}
      />
    {{/let}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Interval: typeof Interval;
  }
}
