import { LinkTo } from '@ember/routing';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { t } from 'ember-intl';

interface Signature {
  Args: {
    mmw: any;
    items: { label: string; route: string }[];
  };
  Blocks: {};
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class MenuMobile extends Component<Signature> {
  <template>
    <@mmw.MobileMenu
      @type='right'
      @maskEnabled='true'
      @shadowEnabled='true'
      as |mm|
    >
      <div role='dialog' aria-modal='true'>
        <div
          class='fixed inset-y-0 right-0 z-10 w-full overflow-y-auto bg-white px-6 py-6 sm:max-w-sm sm:ring-1 sm:ring-gray-900/10'
        >
          <div class='flex items-center justify-between'>
            <button
              type='button'
              class='-m-2.5 rounded-md p-2.5 text-gray-700'
              {{on 'click' mm.actions.close}}
            >
              <span class='sr-only'>{{t 'menu.close-menu'}}</span>
              <svg
                class='h-6 w-6'
                fill='none'
                viewBox='0 0 24 24'
                stroke-width='1.5'
                stroke='currentColor'
                aria-hidden='true'
              >
                <path
                  stroke-linecap='round'
                  stroke-linejoin='round'
                  d='M6 18L18 6M6 6l12 12'
                />
              </svg>
            </button>
          </div>
          <div class='mt-6 flow-root'>
            <div class='-my-6 divide-y divide-gray-500/10'>
              <div class='space-y-2 py-6'>
                {{#each @items as |item|}}
                  <LinkTo
                    class='-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50'
                    @activeClass='text-sky-700 underline'
                    @route={{item.route}}
                    {{on 'click' mm.actions.close}}
                  >
                    {{t item.label}}
                  </LinkTo>
                {{/each}}
              </div>
              {{! <div class='py-6'>
                <a
                  href='#'
                  class='-mx-3 block rounded-lg px-3 py-2.5 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50'
                >Log in</a>
              </div> }}
            </div>
          </div>
        </div>
      </div>
    </@mmw.MobileMenu>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    MenuMobile: typeof MenuMobile;
  }
}
