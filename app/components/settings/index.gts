import Component from '@glimmer/component';
import { Checkbox } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { type IntlService, t } from 'ember-intl';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import set from 'ember-set-helper/helpers/set';
import { Select } from '@frontile/forms';
import { array } from '@ember/helper';

interface SettingsSignature {
  Args: {};
  Element: HTMLDivElement;
}

export default class Settings extends Component<SettingsSignature> {
  @service declare settings: SettingsService;
  @service declare intl: IntlService;

  get providerIds() {
    return [
      {
        key: 'firebase-realtime-database',
        label: this.intl.t('provider-ids.firebase-realtime-database'),
      },
    ];
  }

  <template>
    <div class='flex flex-col w-full md:w-1/2 gap-4 py-4'>
      <Select
        @label={{t 'settings.provider-id.label'}}
        @description={{t 'settings.provider-id.description'}}
        @placeholder={{t 'settings.provider-id.placeholder'}}
        @selectionMode='single'
        @items={{this.providerIds}}
        @allowEmpty={{false}}
        @intent='primary'
        @selectedKeys={{array this.settings.providerId}}
        @onSelectionChange={{set this.settings 'providerId'}}
      />

      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.deviceUrl}}
        @type='text'
        name='deviceUrl'
        @label={{t 'settings.device-url.label'}}
        @description={{t 'settings.device-url.description'}}
        @onChange={{set this.settings 'deviceUrl'}}
      />

      <Checkbox
        @checked={{this.settings.hasOneDaySelection}}
        name='hasOneDaySelection'
        @label={{t 'settings.has-one-day-selection.label'}}
        @description={{t 'settings.has-one-day-selection.description'}}
        @onChange={{set this.settings 'hasOneDaySelection'}}
      />

      <Checkbox
        @checked={{this.settings.isAccuracyVisible}}
        name='isAccuracyVisible'
        @label={{t 'settings.is-accuracy-visible.label'}}
        @description={{t 'settings.is-accuracy-visible.description'}}
        @onChange={{set this.settings 'isAccuracyVisible'}}
      />

      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.refreshInterval}}
        @type='number'
        min='0'
        step='1'
        name='refreshInterval'
        @label={{t 'settings.refresh-interval.label'}}
        @description={{t 'settings.refresh-interval.description'}}
        @onChange={{set this.settings 'refreshInterval'}}
      />
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Settings: typeof Settings;
  }
}
