import Component from '@glimmer/component';
import { Button } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
//@ts-ignore No TS stuff yet
import HeroIcon from 'ember-heroicons/components/hero-icon';
import { Input } from '@frontile/forms';
import set from 'ember-set-helper/helpers/set';
import { hash } from '@ember/helper';
import { ToggleButton } from '@frontile/buttons';

interface DateSelectorSignature {
  Args: {};
  Element: HTMLDivElement;
}

export default class DateSelector extends Component<DateSelectorSignature> {
  @service declare settings: SettingsService;

  <template>
    <div class='flex flex-row flex-wrap gap-4 items-end'>
      <Button
        {{on 'click' (fn this.settings.addDays -1)}}
        @appearance='outlined'
        @size='lg'
      >
        <HeroIcon class='h-4' @icon='chevron-left' />
      </Button>

      {{#if this.settings.hasOneDaySelection}}
        {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
        <Input
          @value={{this.settings.dateFromShort}}
          @type='date'
          name='date'
          @onChange={{set this.settings 'date'}}
          @classes={{hash base='flex-1'}}
        />
      {{else}}
        {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}

        <Input
          @value={{this.settings.dateFromShort}}
          @type='date'
          name='dateFrom'
          @onChange={{set this.settings 'dateFrom'}}
          @classes={{hash base='grow'}}
        />
        {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
        <Input
          @value={{this.settings.dateToShort}}
          @type='date'
          name='dateTo'
          @onChange={{set this.settings 'dateTo'}}
          @classes={{hash base='grow'}}
        />
      {{/if}}

      <ToggleButton
        @isSelected={{this.settings.autoFastForward}}
        @onChange={{this.settings.toggleAutoFastForward}}
        @size='lg'
        @intent='primary'
      >
        {{#if this.settings.autoFastForward}}
          <HeroIcon class='h-4' @icon='eye' />
        {{else}}
          <HeroIcon class='h-4' @icon='eye-slash' />
        {{/if}}
      </ToggleButton>

      <Button
        {{on 'click' (fn this.settings.addDays 1)}}
        @appearance='outlined'
        @size='lg'
      >
        <HeroIcon class='h-4' @icon='chevron-right' />
      </Button>
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    DateSelector: typeof DateSelector;
  }
}
