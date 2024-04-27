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

  PROVIDERS = [
    {
      key: 'firebase-realtime-database',
      label: this.intl.t('providers.firebase-realtime-database'),
    },
  ];

  <template>
    <div class='flex flex-col w-full md:w-1/2 gap-4 py-4'>
      <Select
        @label={{t 'settings.provider.label'}}
        @description={{t 'settings.provider.description'}}
        @placeholder={{t 'settings.provider.placeholder'}}
        @selectionMode='single'
        @items={{this.PROVIDERS}}
        @allowEmpty={{false}}
        @intent='primary'
        @selectedKeys={{array this.settings.provider}}
        @onSelectionChange={{set this.settings 'provider'}}
      />

      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.deviceId}}
        @type='password'
        name='deviceId'
        @label={{t 'settings.device-id.label'}}
        @description={{t 'settings.device-id.description'}}
        @onChange={{set this.settings 'deviceId'}}
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
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Settings: typeof Settings;
  }
}
