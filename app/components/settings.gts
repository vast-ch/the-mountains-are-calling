import Component from '@glimmer/component';
import { Form } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import type { FormSignature } from '@frontile/forms';
import { inject as service } from '@ember/service';
import * as dayjs from 'dayjs';
import type SettingsService from 'the-mountains-are-calling/services/settings';

interface SettingsSignature {
  Args: {};
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Settings extends Component<SettingsSignature> {
  @service declare settings: SettingsService;

  get startDateString() {
    return new Date(this.settings.startDate).toISOString().split('T')[0]; // don't ask, I hate JS
  }
  get endDateString() {
    return new Date(this.settings.endDate).toISOString().split('T')[0]; // don't ask, I hate JS
  }
  get minDate(): string {
    return dayjs(this.settings.data?.[0]?.timestamp).format('YYYY-MM-DD');
  }
  get maxDate() {
    return dayjs(
      this.settings.data?.[this.settings.data.length - 1]?.timestamp,
    ).format('YYYY-MM-DD');
  }

  <template>
    <Form
      @onChange={{this.settings.onChange}}
      class='grid grid-cols-1 sm:grid-cols-3 w-full gap-4 py-4'
    >
      <Input
        @value={{this.settings.deviceId}}
        @type='text'
        name='deviceId'
        @label={{t 'map.form.device-id'}}
        @description={{t 'map.form.do-not-share'}}
      />

      <Input
        @value={{this.startDateString}}
        @type='date'
        name='startDate'
        @label={{t 'map.form.start-date'}}
        min={{this.minDate}}
        max={{this.maxDate}}
        @description={{t 'map.form.min-date' date=this.minDate}}
      />
      <Input
        @value={{this.endDateString}}
        @type='date'
        name='endDate'
        @label={{t 'map.form.end-date'}}
        min={{this.minDate}}
        max={{this.maxDate}}
        @description={{t 'map.form.max-date' date=this.maxDate}}
      />
    </Form>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Settings: typeof Settings;
  }
}
