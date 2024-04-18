import Component from '@glimmer/component';
import { Form } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import type { FormSignature } from '@frontile/forms';
import * as dayjs from 'dayjs';

interface MapFormSignature {
  Args: {
    onChange: FormSignature['Args']['onChange'];
    startDate: number;
    endDate: number;
    deviceId: string;
    data: any[];
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class MapForm extends Component<MapFormSignature> {
  get startDateString() {
    return new Date(this.args.startDate).toISOString().split('T')[0]; // don't ask, I hate JS
  }
  get endDateString() {
    return new Date(this.args.endDate).toISOString().split('T')[0]; // don't ask, I hate JS
  }
  get minDate(): string {
    return dayjs(this.args.data?.[0]?.timestamp).format('YYYY-MM-DD');
  }
  get maxDate() {
    return dayjs(this.args.data?.[this.args.data.length - 1]?.timestamp).format(
      'YYYY-MM-DD',
    );
  }

  <template>
    <Form
      @onChange={{@onChange}}
      class='grid grid-cols-1 sm:grid-cols-3 w-full gap-4 py-4'
    >
      <Input
        @value={{@deviceId}}
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
    MapForm: typeof MapForm;
  }
}
