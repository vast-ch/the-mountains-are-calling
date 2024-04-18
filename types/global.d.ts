import '@glint/environment-ember-loose';

import type EmberIntlRegistry from 'ember-intl/template-registry';

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry
    extends EmberIntlRegistry /* other addon registries */ {
    // local entries
  }
}
