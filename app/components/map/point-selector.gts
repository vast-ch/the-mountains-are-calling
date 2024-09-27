import Component from '@glimmer/component';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
//@ts-expect-error No TS yet
import { sub } from 'ember-math-helpers/helpers/sub';
import { ButtonGroup } from '@frontile/buttons';

import { fn, hash } from '@ember/helper';
//@ts-expect-error No TS yet
import SunCalc from 'suncalc';
//@ts-ignore No TS stuff yet
import { action } from '@ember/object';
//@ts-expect-error No TS yet
import didIntersect from 'ember-scroll-modifiers/modifiers/did-intersect';
//@ts-expect-error No TS yet
import scrollIntoView from 'ember-scroll-modifiers/modifiers/scroll-into-view';
import type { Pin } from 'the-mountains-are-calling/services/settings';
import { eq, or, and } from 'ember-truth-helpers';
import { array } from '@ember/helper';

interface PointSelectorSignature {
  Args: {
    data: any[];
  };
  Element: HTMLDivElement;
}

const COLORS = [
  'border-amber-950',
  'border-amber-900',
  'border-amber-800',
  'border-amber-700',
  'border-amber-600',
  'border-amber-500',
  'border-amber-400',
  'border-amber-300',
  'border-amber-200',
];

function getSunColor(timestamp: number, latitude: number, longitude: number) {
  const now = new Date(timestamp * 1000);
  const calc = SunCalc.getPosition(now, latitude, longitude);
  const l = COLORS.length;

  const i = Math.floor(((calc.altitude + 1) / 2) * l) - 1;

  return COLORS[i];
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

        <ButtonGroup class='gap-x-2' as |g|>
          {{#each @data as |point index|}}
            {{#let
              (eq point.timestamp this.settings.rememberedTimestamp)
              as |isSelected|
            }}
              <g.ToggleButton
                @isSelected={{isSelected}}
                @onChange={{fn this.updateRemembereddPin point}}
                {{scrollIntoView
                  shouldScroll=(or
                    (eq point.timestamp this.settings.rememberedTimestamp)
                    (and
                      (eq this.settings.rememberedTimestamp 'last')
                      (eq index (sub (array @data.length 1)))
                    )
                  )
                  options=(hash behavior='smooth' inline='center')
                }}
                @class='{{getSunColor
                  point.timestamp
                  point.latitude
                  point.longitude
                }}
                relative
                '
              >
                {{#if isSelected}}
                  <img
                    src='/images/pin-remembered.svg'
                    class='absolute mx-3 -mt-4 w-5 aspect-square'
                  />
                {{/if}}
                {{timestampToTime point.timestamp}}
              </g.ToggleButton>
            {{/let}}
          {{/each}}
        </ButtonGroup>
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
