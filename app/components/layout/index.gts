import Component from '@glimmer/component';
// eslint-disable-next-line no-unused-vars
import Menu from './menu';
//@ts-expect-error No TS yet
import MobileMenuWrapper from 'ember-mobile-menu/components/mobile-menu-wrapper';

interface Signature {
  Args: {};
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Layout extends Component<Signature> {
  <template>
    <MobileMenuWrapper as |mmw|>
      <div
        class='mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 h-lvh flex flex-col pb-4 sm:pb-6 lg:pb-8'
      >

        <header class='bg-white'>
          <Menu @mmw={{mmw}} />
        </header>

        {{yield}}

      </div>
    </MobileMenuWrapper>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Layout: typeof Layout;
  }
}
