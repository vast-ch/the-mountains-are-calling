import Component from '@glimmer/component';
import { service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { firebaseQuery } from 'the-mountains-are-calling/builders/firebase';
import { use, cell, resource, type Reactive } from 'ember-resources';
import { Cell } from '@starbeam/universal';

export type ClockNakedSignature = {
  percentage: Cell<number>;
  counter: Cell<number>;
};

export type ClockSignature = Reactive<ClockNakedSignature>;

interface Signature {
  Args: {};
  Blocks: {
    default: [ClockNakedSignature];
  };
  Element: HTMLDivElement;
}

const Clock = resource(({ on }) => {
  const counter = cell(0);
  const percentage = cell(0);

  const timer = setInterval(() => {
    percentage.set((percentage.current + 1) % 100);
    if (percentage.current === 0) {
      counter.set(counter.current + 1);
    }
  }, 1000);

  on.cleanup(() => {
    clearInterval(timer);
  });

  return { percentage, counter };
});

export default class Refresher extends Component<Signature> {
  @service mountainsStore: any;
  @service declare settings: SettingsService;

  clock = use(this, Clock);

  get request() {
    return this.mountainsStore.requestManager.request(
      firebaseQuery(
        this.settings.deviceUrl,
        this.settings.dateFrom,
        this.settings.dateTo,
        this.clock.current.counter.current,
      ),
    );
  }

  <template>{{yield this.clock}}</template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Refresher: typeof Refresher;
  }
}
