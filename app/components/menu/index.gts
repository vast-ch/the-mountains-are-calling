import Component from '@glimmer/component';
// eslint-disable-next-line no-unused-vars
import MenuMobile from './mobile';
import MenuDesktop from './desktop';

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class Menu extends Component {
  <template>
    <header class='bg-white'>
      <MenuDesktop />
      {{! <MenuMobile /> TODO: ember-mobile-menu }}
    </header>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Menu: typeof Menu;
  }
}
