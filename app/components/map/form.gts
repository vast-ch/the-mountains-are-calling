import Component from '@glimmer/component';
import { Form } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import type { FormSignature } from '@frontile/forms';

interface MapFormSignature {
  Args: {
    onChange: FormSignature['Args']['onChange'];
    startDate: Date;
    endDate: Date;
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class MapForm extends Component<MapFormSignature> {
  get startDateString() {
    return this.args.startDate.toISOString().split('T')[0]; // don't ask, I hate JS
  }
  get endDateString() {
    return this.args.endDate.toISOString().split('T')[0]; // don't ask, I hate JS
  }

  <template>
    <Form @onChange={{@onChange}} class='grid grid-cols-2 w-full gap-4 py-4'>
      <Input
        @value={{this.startDateString}}
        @type='date'
        @name='startDate'
        @label={{t 'map.form.startDate'}}
      />
      <Input
        @value={{this.endDateString}}
        @type='date'
        @name='endDate'
        @label={{t 'map.form.endDate'}}
      />
    </Form>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    MapForm: typeof MapForm;
  }
}
