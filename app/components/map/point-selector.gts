import Component from '@glimmer/component';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { Button } from '@frontile/buttons';
import { tracked } from '@glimmer/tracking';
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
import { t } from 'ember-intl';
import { eq } from 'ember-truth-helpers';
import { on } from '@ember/modifier';

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

  @tracked intersectedPin: Pin | undefined = undefined;

  @action updateHighlightedPin(pin: Pin | undefined) {
    this.settings.highlightedPin = pin?.timestamp;
  }

  @action onIntersect(pin: Pin) {
    this.intersectedPin = pin;
  }

  @action onScrollEnd() {
    this.updateHighlightedPin(this.intersectedPin);
  }

  <template>
    <div
      class='grid [grid-template-areas:"stack"] justify-items-center items-start'
    >

      <div
        class='overflow-x-scroll snap-x py-2 w-full [grid-area:stack] flex flex-row gap-x-4'
        {{on 'scrollend' (fn this.onScrollEnd)}}
      >
        <div><div class='[width:50vw] text-right'></div></div>

        <ButtonGroup as |g|>
          {{#each @data as |point|}}
            <g.ToggleButton
              @isSelected={{eq point.timestamp this.settings.highlightedPin}}
              @onChange={{fn this.updateHighlightedPin point}}
              {{(if
                (eq point.timestamp this.settings.highlightedPin)
                (modifier
                  scrollIntoView
                  shouldScroll=true
                  options=(hash behavior='smooth' inline='center')
                )
              )}}
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
        <div><div class='[width:50vw]'></div></div>

      </div>

      <div
        class='w-24 border-x-2 border-y-2 border-gray-400 rounded [grid-area:stack] h-full'
      >
      </div>
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    PointSelector: typeof PointSelector;
  }
}
