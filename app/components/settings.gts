import Component from '@glimmer/component';
import { Checkbox } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import set from 'ember-set-helper/helpers/set';

interface SettingsSignature {
  Args: {};
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Settings extends Component<SettingsSignature> {
  @service declare settings: SettingsService;

  <template>
    <div class='grid grid-cols-1 sm:grid-cols-2 w-full gap-4 py-4'>
      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.deviceId}}
        @type='text'
        name='deviceId'
        @label={{t 'settings.device-id.label'}}
        @description={{t 'settings.device-id.description'}}
        @onChange={{set this.settings 'deviceId'}}
      />

      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.dateShort}}
        @type='date'
        name='date'
        @label={{t 'settings.date.label'}}
        @description={{t 'settings.date.description'}}
        @onChange={{set this.settings 'date'}}
      />

      <Checkbox
        @checked={{this.settings.isAccuracyVisible}}
        name='isAccuracyVisible'
        @label={{t 'settings.is-accuracy-visible.label'}}
        @description={{t 'settings.is-accuracy-visible.description'}}
        @onChange={{set this.settings 'isAccuracyVisible'}}
      />

      <Checkbox
        @checked={{this.settings.hasOneDaySelection}}
        name='hasOneDaySelection'
        @label={{t 'settings.has-one-day-selection.label'}}
        @description={{t 'settings.has-one-day-selection.description'}}
        @onChange={{set this.settings 'hasOneDaySelection'}}
      />
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Settings: typeof Settings;
  }
}
