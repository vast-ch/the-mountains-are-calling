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

  @action updateHighlightedPin(timestamp: number | undefined) {
    this.settings.rememberedPin = timestamp;
  }

  // @action onIntersect(pin: Pin) {
  //   this.settings.highlightedPin = pin.timestamp;
  // }

  <template>
    <div class=''>
      <div class='flex w-full justify-center'>
        <div class='border-t-4 border-gray-400 w-8'>
          {{! Center marker }}
        </div>
      </div>

      <div class='overflow-x-scroll py-2 w-full flex flex-row'>
        <div><div class={{this.snapAreaPadding}}></div></div>

        <ButtonGroup class='gap-x-4' as |g|>
          {{#each @data as |point index|}}
            <g.ToggleButton
              @isSelected={{eq point.timestamp this.settings.rememberedPin}}
              @onChange={{fn this.updateHighlightedPin point.timestamp}}
              {{scrollIntoView
                shouldScroll=(or
                  (eq point.timestamp this.settings.rememberedPin)
                  (and
                    (eq this.settings.rememberedPin 'last')
                    (eq index (sub (array @data.length 1)))
                  )
                )
                options=(hash behavior='smooth' inline='center')
              }}
              @class={{getSunColor
                point.timestamp
                point.latitude
                point.longitude
              }}
            >
              {{timestampToTime point.timestamp}}
            </g.ToggleButton>
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
