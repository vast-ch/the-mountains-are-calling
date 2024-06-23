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

const MENU_ITEMS = [
  { label: 'route.map', route: 'index' },
  { label: 'route.settings', route: 'settings' },
  { label: 'route.help', route: 'help' },
];

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Menu extends Component<Signature> {
  <template>
    <header class='bg-white'>
      <MenuDesktop @mmw={{@mmw}} @items={{MENU_ITEMS}} />
      <MenuMobile @mmw={{@mmw}} @items={{MENU_ITEMS}} />
    </header>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Menu: typeof Menu;
  }
}
