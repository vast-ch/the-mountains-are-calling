import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import { Request } from '@warp-drive/ember';
import { t } from 'ember-intl';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { firebaseQuery } from 'the-mountains-are-calling/builders/firebase';
import { hash } from '@ember/helper';
import { use, cell, resource } from 'ember-resources';
import Refresher from '../refresher';
import { fn } from '@ember/helper';
import { action } from '@ember/object';

interface Signature {
  Args: {};
  Blocks: {
    default: [
      {
        result: any;
        refresher: {};
      },
    ];
  };
  Element: HTMLDivElement;
}

export default class Loader extends Component<Signature> {
  @service mountainsStore: any;
  @service declare settings: SettingsService;

  @action
  request(counter: number) {
    return this.mountainsStore.requestManager.request(
      firebaseQuery(
        this.settings.deviceUrl,
        this.settings.dateFrom,
        this.settings.dateTo,
        counter,
      ),
    );
  }

  <template>
    <Refresher as |r|>
      <Request
        @request={{(this.request r.current.counter.current)}}
        @autorefreshBehavior='reload'
      >
        <:loading>
          {{t 'map.loading'}}
        </:loading>

        <:content as |result|>
          {{yield (hash result=result refresher=r)}}
        </:content>
      </Request>
    </Refresher>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Loader: typeof Loader;
  }
}
