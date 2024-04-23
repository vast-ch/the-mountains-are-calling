import Component from '@glimmer/component';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';
import { Button } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn, hash } from '@ember/helper';
import { Input } from '@frontile/forms';
//@ts-expect-error No TS yet
import SunCalc from 'suncalc';
import { on } from '@ember/modifier';
//@ts-ignore No TS stuff yet
import HeroIcon from 'ember-heroicons/components/hero-icon';
import { action } from '@ember/object';
//@ts-expect-error No TS yet
import didIntersect from 'ember-scroll-modifiers/modifiers/did-intersect';
import type { Point } from 'the-mountains-are-calling/services/settings';
import { t } from 'ember-intl';
import set from 'ember-set-helper/helpers/set';

interface MapFormSignature {
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

  const i = Math.floor(((calc.altitude + 1) / 2) * l);

  return COLORS[i];
}

export default class MapForm extends Component<MapFormSignature> {
  @service declare settings: SettingsService;

  @action onEnter(point: Point) {
    this.settings.highlightedPoint = point;
  }

  <template>
    <div class='flex flex-row gap-4'>
      <Button
        {{on 'click' (fn this.settings.addDays -1)}}
        @appearance='outlined'
      >
        <HeroIcon class='h-4' @icon='chevron-left' />
      </Button>
      {{! template-lint-disable no-unknown-arguments-for-builtin-components require-input-label }}
      <Input
        @value={{this.settings.dateShort}}
        @type='date'
        @classes={{hash base='flex-1'}}
        @onChange={{set this.settings 'date'}}
      />
      <Button
        {{on 'click' (fn this.settings.addDays 1)}}
        @appearance='outlined'
      >
        <HeroIcon class='h-4' @icon='chevron-right' />
      </Button>
    </div>

    <div
      class='grid [grid-template-areas:"stack"] justify-items-center items-start py-2'
    >
      <div
        class='w-28 pt-2 border border-gray-400 rounded [grid-area:stack] text-center h-full'
      >
        {{t 'map.highlighted.label'}}
      </div>

      <div
        class='overflow-x-scroll pt-10 py-2 snap-x w-full [grid-area:stack] flex flex-row gap-x-4'
      >
        <div><div class='[width:50vw] text-right'></div></div>
        {{#each @data as |point|}}
          <div
            {{didIntersect
              onEnter=(fn this.onEnter point)
              options=(hash rootMargin='0% -49% 0% -49%' threshold=0)
            }}
            class='{{getSunColor
                point.timestamp
                point.latitude
                point.longitude
              }}
              border-2 snap-center px-4 py-2 rounded bg-white'
          >{{timestampToTime point.timestamp}}</div>
        {{/each}}
        <div><div class='[width:50vw]'></div></div>
      </div>

    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    MapForm: typeof MapForm;
  }
}
