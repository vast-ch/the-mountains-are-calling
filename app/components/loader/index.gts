import Component from '@glimmer/component';
import { service } from '@ember/service';
// @ts-expect-error No TS stuff yet
import { Request } from '@warp-drive/ember';
import { t } from 'ember-intl';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { firebaseQuery } from 'the-mountains-are-calling/builders/firebase';
import { hash } from '@ember/helper';
import { gt } from 'ember-truth-helpers';

interface Signature {
  Args: {};
  Blocks: {
    default: [
      {
        result: any;
      },
    ];
  };
  Element: HTMLDivElement;
}

export default class Loader extends Component<Signature> {
  @service mountainsStore: any;
  @service declare settings: SettingsService;

  get request() {
    return this.mountainsStore.requestManager.request(
      firebaseQuery(
        this.settings.deviceUrl,
        this.settings.dateFrom,
        this.settings.dateTo,
      ),
    );
  }

  <template>
    {{log this.settings.refreshIntervalMs}}
    <Request
      @request={{this.request}}
      @autorefresh={{gt this.settings.refreshInterval 0}}
      @autorefreshThreshold={{this.settings.refreshIntervalMs}}
      @autorefreshBehavior='refresh'
    >
      <:loading>
        {{t 'map.loading'}}
      </:loading>

      <:content as |result|>
        {{yield (hash result=result)}}
      </:content>
    </Request>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Loader: typeof Loader;
  }
}
