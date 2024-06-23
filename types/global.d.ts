import '@glint/environment-ember-loose';
import { ComponentLike } from '@glint/template';
import type EmberPageTitleTemplateRegistry from 'ember-page-title/template-registry';
import type EmberIntlRegistry from 'ember-intl/template-registry';
import type EmberTruthRegistry from 'ember-truth-helpers/template-registry';
import type EmberPhosphorIconsRegistery from 'ember-phosphor-icons/template-registry';

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry extends EmberPageTitleTemplateRegistry {
    WelcomePage: ComponentLike;
  }

  export default interface Registry
    extends EmberIntlRegistry /* other addon registries */ {
    // local entries
  }

  export default interface Registry
    extends EmberTruthRegistry /* other addon registries */ {
    // local entries
  }

  export default interface Registry
    extends EmberPhosphorIconsRegistery /* ... */ {
    // local entries
  }
}
