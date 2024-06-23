import Component from '@glimmer/component';
import Calendar from 'ember-phosphor-icons/components/ph-calendar';
import CalendarHeart from 'ember-phosphor-icons/components/ph-calendar-heart';
import Ruler from 'ember-phosphor-icons/components/ph-ruler';
import Mountains from 'ember-phosphor-icons/components/ph-mountains';
import BatteryHigh from 'ember-phosphor-icons/components/ph-battery-high';
import Speedometer from 'ember-phosphor-icons/components/ph-speedometer';
import ClockUser from 'ember-phosphor-icons/components/ph-clock-user';
import { t } from 'ember-intl';

interface Signature {
  Args: {};
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

export default class Help extends Component<Signature> {
  ICONS = [
    { icon: Calendar, label: 'help.icons.timestamp' },
    { icon: CalendarHeart, label: 'help.icons.relative' },
    { icon: Ruler, label: 'help.icons.accuracy' },
    { icon: Mountains, label: 'help.icons.altitude' },
    { icon: BatteryHigh, label: 'help.icons.battery' },
    { icon: Speedometer, label: 'help.icons.velocity' },
    { icon: ClockUser, label: 'help.icons.fix-age' },
  ];

  <template>
    <div class='overflow-hidden bg-white shadow sm:rounded-lg'>
      <div class='px-4 py-6 sm:px-6'>
        <h3 class='text-base font-semibold leading-7 text-gray-900'>
          {{t 'help.icons.heading'}}
        </h3>
      </div>
      <div class='border-t border-gray-100'>
        <dl class='divide-y divide-gray-100'>
          {{#each this.ICONS as |elm|}}
            <div class='px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6'>
              <dt class='text-sm font-medium text-gray-900'>
                <elm.icon @size='24' />
              </dt>
              <dd
                class='mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0'
              >
                {{t elm.label}}
              </dd>
            </div>
          {{/each}}
        </dl>
      </div>
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Help: typeof Help;
  }
}
