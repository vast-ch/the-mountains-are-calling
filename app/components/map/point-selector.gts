import Component from '@glimmer/component';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
//@ts-expect-error No TS yet
import { sub } from 'ember-math-helpers/helpers/sub';
import { ButtonGroup } from '@frontile/buttons';

import { fn, hash } from '@ember/helper';
//@ts-ignore No TS stuff yet
import { action } from '@ember/object';
//@ts-expect-error No TS yet
import scrollIntoView from 'ember-scroll-modifiers/modifiers/scroll-into-view';
import type { Pin } from 'the-mountains-are-calling/services/settings';
import { eq, or, and } from 'ember-truth-helpers';
import { array } from '@ember/helper';
import accuracyToColour from 'the-mountains-are-calling/helpers/accuracy-to-colour';
import { Button } from '@frontile/buttons';
import { on } from '@ember/modifier';
import rememberedPin from './pin/remembered';

interface PointSelectorSignature {
  Args: {
    data: any[];
    rememberedPin: Pin | undefined;
  };
  Element: HTMLDivElement;
}

export default class PointSelector extends Component<PointSelectorSignature> {
  @service declare settings: SettingsService;

  // 50vw - 50% of the viewport
  // -3rem - 1/2 of the button
  // Note: Do not try to put more there or else: Attempted to rerender, but the Ember application has had an unrecoverable error occur during render. You should reload the application after fixing the cause of the error.
  snapAreaPadding = '[width:calc(50vw-3rem)]';

  @action updateRemembereddPin(pin: Pin) {
    this.settings.rememberedTimestamp = pin.timestamp;
    this.settings.latitude = pin.latitude;
    this.settings.longitude = pin.longitude;
  }

  <template>
    <div>
      <div class='overflow-x-scroll py-2 w-full flex flex-row'>
        <div><div class={{this.snapAreaPadding}}></div></div>

        <div class='gap-x-2 flex'>
          {{#each @data as |point index|}}
            {{#let
              (eq point.timestamp @rememberedPin.timestamp)
              as |isSelected|
            }}
              <Button
                {{on 'click' (fn this.updateRemembereddPin point)}}
                {{scrollIntoView
                  shouldScroll=(eq point.timestamp @rememberedPin.timestamp)
                  options=(hash behavior='smooth' inline='center')
                }}
                @class='relative {{if isSelected "ring ring-offset-2"}}'
                style='background-color: {{accuracyToColour point.accuracy}}'
              >
                {{#if isSelected}}
                  <img
                    src='/images/pin-remembered.svg'
                    class='absolute mx-3 -mt-4 w-5 aspect-square'
                  />
                {{/if}}
                {{timestampToTime point.timestamp}}
              </Button>
            {{/let}}
          {{/each}}
        </div>

        <div><div class={{this.snapAreaPadding}}></div></div>

      </div>

    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    PointSelector: typeof PointSelector;
  }
}
