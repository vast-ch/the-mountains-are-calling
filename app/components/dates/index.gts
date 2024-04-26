import Component from '@glimmer/component';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import set from 'ember-set-helper/helpers/set';
import { hash } from '@ember/helper';

interface DatesSignature {
  Args: {};
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Dates extends Component<DatesSignature> {
  @service declare settings: SettingsService;

  <template>
    {{#if this.settings.hasOneDaySelection}}
      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.dateFromShort}}
        @type='date'
        name='date'
        @label={{t 'settings.date.label'}}
        @description={{t 'settings.date.description'}}
        @onChange={{set this.settings 'date'}}
        @classes={{hash base='flex-1'}}
      />
    {{else}}
      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.dateFromShort}}
        @type='date'
        name='dateFrom'
        @label={{t 'settings.date-from.label'}}
        @description={{t 'settings.date-from.description'}}
        @onChange={{set this.settings 'dateFrom'}}
        @classes={{hash base='w-1/2'}}
      />
      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.dateToShort}}
        @type='date'
        name='dateTo'
        @label={{t 'settings.date-to.label'}}
        @description={{t 'settings.date-to.description'}}
        @onChange={{set this.settings 'dateTo'}}
        @classes={{hash base='w-1/2'}}
      />
    {{/if}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Dates: typeof Dates;
  }
}
