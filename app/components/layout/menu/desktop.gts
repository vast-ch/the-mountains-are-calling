import Component from '@glimmer/component';
import { t } from 'ember-intl';

interface Signature {
  Args: {
    mmw: any;
  };
  Blocks: {};
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class MenuDesktop extends Component<Signature> {
  <template>
    <nav class='flex items-center justify-between py-6' aria-label='Global'>
      <div class='flex lg:flex-1'>
        <a href='#' class='-m-1.5 p-1.5 flex flex-row gap-4 items-end'>
          {{! TODO: make this EmberResponsiveImage }}
          <img
            class='h-8 w-8'
            src='/assets/icons/appicon-512.png'
            alt='The Mountains Are Calling logo'
          />
          <h1
            class='text-sky-500 font-extrabold font-mono hidden sm:inline sm:text-2xl'
          >{{t 'project.name'}}</h1>
        </a>
      </div>
      <div class='flex lg:hidden'>
        <@mmw.Toggle
          class='-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-700'
        >
          <span class='sr-only'>{{t 'menu.open-main-menu'}}</span>
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
              d='M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5'
            />
          </svg>
        </@mmw.Toggle>

      </div>
      {{! <div class='hidden lg:flex lg:gap-x-12'>
        <a
          href='#'
          class='text-sm font-semibold leading-6 text-gray-900'
        >Product</a>
        <a
          href='#'
          class='text-sm font-semibold leading-6 text-gray-900'
        >Features</a>
        <a
          href='#'
          class='text-sm font-semibold leading-6 text-gray-900'
        >Marketplace</a>
        <a
          href='#'
          class='text-sm font-semibold leading-6 text-gray-900'
        >Company</a>
      </div>
      <div class='hidden lg:flex lg:flex-1 lg:justify-end'>
        <a href='#' class='text-sm font-semibold leading-6 text-gray-900'>Log in
          <span aria-hidden='true'>&rarr;</span></a>
      </div> }}
    </nav>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    MenuDesktop: typeof MenuDesktop;
  }
}
