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
  // -1.5rem - page padding
  // -2px - button border
  // -16px - button left margin
  snapAreaPadding = '[width:calc(50vw-3rem-1.5rem-2px-16px)]';

  @action updateHighlightedPin(timestamp: number | undefined) {
    this.settings.rememberedPin = timestamp;
  }

  @action onIntersect(pin: Pin) {
    this.settings.highlightedPin = pin.timestamp;
  }

  <template>
    <div
      class='grid [grid-template-areas:"stack"] justify-items-center items-start'
    >
      <div class='w-24 pb-4 [grid-area:stack] h-full'>
        <div class='border-2 border-gray-400 rounded h-full w-full'>
          {{! The peeking window has to live here in the DOM, otherwise it would overlay the scroll area and hinder scrolling}}
        </div>
      </div>

      <div
        class='overflow-x-scroll snap-x snap-mandatory pt-2 pb-6 w-full [grid-area:stack] flex flex-row gap-x-4'
      >
        {{!

        }}
        <div><div class={{this.snapAreaPadding}}></div></div>

        <ButtonGroup as |g|>
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
              {{didIntersect
                onEnter=(fn this.onIntersect point)
                options=(hash rootMargin='0% -49% 0% -49%' threshold=0)
              }}
              @class='{{getSunColor
                point.timestamp
                point.latitude
                point.longitude
              }}
               snap-center mx-4'
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
