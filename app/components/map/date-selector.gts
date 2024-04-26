import Component from '@glimmer/component';
import { Button } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn, hash } from '@ember/helper';
import { Input } from '@frontile/forms';
//@ts-expect-error No TS yet
import SunCalc from 'suncalc';
import { on } from '@ember/modifier';
//@ts-ignore No TS stuff yet
import HeroIcon from 'ember-heroicons/components/hero-icon';
import { action } from '@ember/object';
import type { Point } from 'the-mountains-are-calling/services/settings';
import set from 'ember-set-helper/helpers/set';

interface DateSelectorSignature {
  Args: {};
  Element: HTMLDivElement;
}

export default class DateSelector extends Component<DateSelectorSignature> {
  @service declare settings: SettingsService;

  <template>
    <div class='flex flex-row gap-4'>
      <Button
        {{on 'click' (fn this.settings.addDays -1)}}
        @appearance='outlined'
      >
        <HeroIcon class='h-4' @icon='chevron-left' />
      </Button>
      {{#if this.settings.hasOneDaySelection}}
        {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
        <Input
          @value={{this.settings.dateShort}}
          @type='date'
          @classes={{hash base='flex-1'}}
          @onChange={{set this.settings 'date'}}
        />
      {{else}}
        {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
        <Input
          @value={{this.settings.dateShort}}
          @type='date'
          @classes={{hash base='w-1/2'}}
          @onChange={{set this.settings 'date'}}
        />
        {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
        <Input
          @value={{this.settings.dateShort}}
          @type='date'
          @classes={{hash base='w-1/2'}}
          @onChange={{set this.settings 'date'}}
        />
      {{/if}}
      <Button
        {{on 'click' (fn this.settings.addDays 1)}}
        @appearance='outlined'
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
