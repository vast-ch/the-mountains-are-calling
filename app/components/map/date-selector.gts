import Component from '@glimmer/component';
import { Button } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn, hash } from '@ember/helper';
import { Input } from '@frontile/forms';
import { on } from '@ember/modifier';
//@ts-ignore No TS stuff yet
import HeroIcon from 'ember-heroicons/components/hero-icon';
import Dates from '../dates';

interface DateSelectorSignature {
  Args: {};
  Element: HTMLDivElement;
}

export default class DateSelector extends Component<DateSelectorSignature> {
  @service declare settings: SettingsService;

  <template>
    <div class='flex flex-row gap-4 items-end'>
      <Button
        {{on 'click' (fn this.settings.addDays -1)}}
        @appearance='outlined'
        @size='lg'
      >
        <HeroIcon class='h-4' @icon='chevron-left' />
      </Button>

      <Dates />

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
