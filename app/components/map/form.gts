import Component from '@glimmer/component';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';
import { Button, ButtonGroup } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn, hash } from '@ember/helper';
import { Form } from '@frontile/forms';
import { Input } from '@frontile/forms';
import { t } from 'ember-intl';
import { eq } from 'ember-truth-helpers';
//@ts-expect-error No TS yet
import SunCalc from 'suncalc';
import { LinkTo } from '@ember/routing';
import { on } from '@ember/modifier';
//@ts-ignore No TS stuff yet
import HeroIcon from 'ember-heroicons/components/hero-icon';

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

  <template>
    <div class='flex flex-row gap-4'>
      <Button
        {{on 'click' (fn this.settings.addDays -1)}}
        @appearance='outlined'
      >
        <HeroIcon class='h-4' @icon='chevron-left' />
      </Button>
      <Input
        @value={{this.settings.dateShort}}
        @type='date'
        @classes={{hash base='flex-1'}}
        @onChange={{fn (mut this.settings.date)}}
      />
      <Button
        {{on 'click' (fn this.settings.addDays 1)}}
        @appearance='outlined'
      >
        <HeroIcon class='h-4' @icon='chevron-right' />
      </Button>
    </div>

    <div class='overflow-x-scroll py-4'>
      <ButtonGroup as |g|>
        {{#each @data as |point|}}
          <g.ToggleButton
            @isSelected={{eq
              point.timestamp
              this.settings.highlightedTimestamp
            }}
            @onChange={{(fn
              this.settings.updateHighlightedTimestamp point.timestamp
            )}}
            @class='{{getSunColor
              point.timestamp
              point.latitude
              point.longitude
            }} border-2'
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
