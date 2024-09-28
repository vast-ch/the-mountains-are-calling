import Component from '@glimmer/component';
import { Button } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { Input } from '@frontile/forms';
import set from 'ember-set-helper/helpers/set';
import { hash } from '@ember/helper';
import { ToggleButton } from '@frontile/buttons';
// import SkipBack from 'ember-phosphor-icons/components/ph-skip-back';
// import SkipForward from 'ember-phosphor-icons/components/ph-skip-forward';
import MapPin from 'ember-phosphor-icons/components/ph-map-pin';

interface DateSelectorSignature {
  Args: {};
  Element: HTMLDivElement;
}

export default class DateSelector extends Component<DateSelectorSignature> {
  @service declare settings: SettingsService;

  <template>
    <div class='flex flex-row flex-wrap gap-4 items-end'>
      {{!-- <Button
        {{on 'click' (fn this.settings.addDays -1)}}
        @appearance='outlined'
      >
        <SkipBack />
      </Button> --}}

      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.dateFromShort}}
        @type='date'
        name='date'
        @onChange={{set this.settings 'date'}}
        @classes={{hash base='flex-1'}}
        @size='lg'
      />

      <ToggleButton
        @isSelected={{this.settings.isAutoFastForward}}
        @onChange={{this.settings.toggleAutoFastForward}}
        @intent='primary'
        @size='lg'
      >
        <MapPin />
      </ToggleButton>

      {{!-- <Button
        {{on 'click' (fn this.settings.addDays 1)}}
        @appearance='outlined'
      >
        <SkipForward />
      </Button> --}}
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    DateSelector: typeof DateSelector;
  }
}
