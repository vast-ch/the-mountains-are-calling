import Component from '@glimmer/component';
import timestampToTime from 'the-mountains-are-calling/helpers/timestamp-to-time';
import { ButtonGroup } from '@frontile/buttons';
import { inject as service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import { fn } from '@ember/helper';
import { eq } from 'ember-truth-helpers';
//@ts-expect-error No TS yet
import SunCalc from 'suncalc';
import { LinkTo } from '@ember/routing';

interface MapFormSignature {
  Args: {
    data: any[];
  };
  Element: HTMLDivElement;
}

const COLORS = [
  'bg-amber-950 text-white',
  'bg-amber-900 text-white',
  'bg-amber-800 text-white',
  'bg-amber-700 text-white',
  'bg-amber-600',
  'bg-amber-500',
  'bg-amber-400',
  'bg-amber-300',
  'bg-amber-200',
  'bg-amber-100',
  'bg-amber-50',
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
    <div>
      <LinkTo
        @route='settings'
        class='inline-flex items-center rounded-md bg-gray-50 px-2 py-1 text-xs font-medium text-gray-600 ring-1 ring-inset ring-gray-500/10 hover:bg-sky-100 hover:border-sky-500'
      >{{this.settings.dateShort}}
      </LinkTo>
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
            @class={{getSunColor
              point.timestamp
              point.latitude
              point.longitude
            }}
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
