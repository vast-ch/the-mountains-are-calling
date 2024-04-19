import Component from '@glimmer/component';
import { Form } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import type { FormSignature } from '@frontile/forms';
import * as dayjs from 'dayjs';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';

interface MapFormSignature {
  Args: {
    data: any[];
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class MapForm extends Component<MapFormSignature> {
  <template>
    <Input
      @type='range'
      list='datapoints'
      step='1'
      min='0'
      max={{@data.length}}
    />
    <datalist
      id='datapoints'
      class='flex flex-col justify-between [writing-mode:vertical-lr]'
    >
      {{#each @data as |point|}}
        <option
          value={{point.timestamp}}
          label={{timestampToTime point.timestamp}}
        />
      {{/each}}
    </datalist>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    MapForm: typeof MapForm;
  }
}
