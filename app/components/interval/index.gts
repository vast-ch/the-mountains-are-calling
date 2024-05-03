import Component from '@glimmer/component';
import { use, resource } from 'ember-resources';
import dayjs from 'dayjs';

interface Signature {
  Args: {
    period: number;
    fn: () => {};
  };
  Blocks: {};
  Element: HTMLDivElement;
}

export default class Interval extends Component<Signature> {
  clock = use(
    this,
    resource(({ on }) => {
      let lastRefreshTime = dayjs();

      const timer = setInterval(() => {
        if (this.args.period) {
          const diff = dayjs().diff(lastRefreshTime, 'seconds');

          console.log(diff);
          if (diff >= this.args.period) {
            lastRefreshTime = dayjs();
            this.args.fn();
          }
        }
      }, 1000);

      on.cleanup(() => {
        clearInterval(timer);
      });
    }),
  );

  <template>{{this.clock}}</template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Interval: typeof Interval;
  }
}
