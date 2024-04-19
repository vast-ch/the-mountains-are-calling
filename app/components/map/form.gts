import Component from '@glimmer/component';
import { Form } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import type { FormSignature } from '@frontile/forms';
import * as dayjs from 'dayjs';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';
import { ButtonGroup } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn } from '@ember/helper';
import { eq } from 'ember-truth-helpers';

interface MapFormSignature {
  Args: {
    data: any[];
  };
  Element: HTMLDivElement;
}

// eslint-disable-next-line ember/no-empty-glimmer-component-classes
export default class MapForm extends Component<MapFormSignature> {
  @service declare settings: SettingsService;

  <template>
    <div class='overflow-x-scroll py-4'>
      <ButtonGroup @size='sm' @intent='primary' as |g|>
        {{#each @data as |point|}}
          <g.ToggleButton
            @isSelected={{eq
              point.timestamp
              this.settings.highlightedTimestamp
            }}
            @onChange={{(fn
              this.settings.updateHighlightedTimestamp point.timestamp
            )}}
          >{{timestampToTime point.timestamp}}</g.ToggleButton>
        {{/each}}
      </ButtonGroup>
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    MapForm: typeof MapForm;
  }
}
