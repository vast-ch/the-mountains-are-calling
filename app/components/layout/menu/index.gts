import Component from '@glimmer/component';
import MenuMobile from './mobile';
import MenuDesktop from './desktop';

interface Signature {
  Args: {
    mmw: any;
  };
  Blocks: {};
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Menu extends Component<Signature> {
  <template>
    <MenuDesktop @mmw={{@mmw}} />
    <MenuMobile @mmw={{@mmw}} />
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Menu: typeof Menu;
  }
}
