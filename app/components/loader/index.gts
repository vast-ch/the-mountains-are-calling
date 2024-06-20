import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import { Request } from '@warp-drive/ember';
import { t } from 'ember-intl';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { firebaseQuery } from 'the-mountains-are-calling/builders/firebase';
import { hash } from '@ember/helper';
import { gt } from 'ember-truth-helpers';

import dayjs from 'dayjs';
import type StoreService from 'the-mountains-are-calling/services/store';

interface Signature {
  Args: {};
  Blocks: {
    default: [
      {
        result: any;
        state: any;
      },
    ];
  };
  Element: HTMLDivElement;
}

export default class Loader extends Component<Signature> {
  @service declare store: StoreService;
  @service declare settings: SettingsService;

  get request() {
    return this.store.request(
      firebaseQuery(
        this.settings.deviceUrl,
        this.settings.dateFrom,
        this.settings.dateTo,
      ),
    );
  }

  <template>
    <Request @request={{this.request}}>
      <:loading>
        {{t 'map.loading'}}
      </:loading>

      <:content as |result state|>
        {{yield (hash result=result state=state)}}
      </:content>
    </Request>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Loader: typeof Loader;
  }
}
