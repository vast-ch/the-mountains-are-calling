import Component from '@glimmer/component';
//@ts-ignore No TS stuff yet
import HeroIcon from 'ember-heroicons/components/hero-icon';
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
    { icon: 'calendar', label: 'help.icons.timestamp' },
    { icon: 'clock', label: 'help.icons.relative' },
    { icon: 'magnifying-glass', label: 'help.icons.accuracy' },
    { icon: 'arrow-trending-up', label: 'help.icons.altitude' },
    { icon: 'battery-50', label: 'help.icons.battery' },
    { icon: 'forward', label: 'help.icons.velocity' },
    { icon: 'arrows-pointing-in', label: 'help.icons.fix-age' },
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
              <dt class='text-sm font-medium text-gray-900'><HeroIcon
                  class='h-4'
                  @icon={{elm.icon}}
                /></dt>
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
