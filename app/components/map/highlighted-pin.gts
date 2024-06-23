import Component from '@glimmer/component';
import type { Pin } from 'the-mountains-are-calling/services/settings';
import { formatNumber, t } from 'ember-intl';
//@ts-ignore No TS
import { icon } from 'ember-leaflet/helpers/icon';
import { service } from '@ember/service';
import type SettingsService from 'the-mountains-are-calling/services/settings';
import dayjs from 'dayjs';
import { Point } from 'leaflet';
//@ts-ignore HeroIcon nope
import HeroIcon from 'ember-heroicons/components/hero-icon';
import duration from 'dayjs/plugin/duration';

// TODO: Is there a better place?
dayjs.extend(duration);

const pinHighlighted = icon([], {
  iconUrl: '/images/pin-highlighted.svg',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  tooltipAnchor: [16, -28],
  shadowSize: [41, 41],
});

function pickHighlightedPin(
  points: Pin[],
  highlightedPinTimestamp: number | undefined,
): Pin | undefined {
  return points.find((p) => p.timestamp === highlightedPinTimestamp);
}

function highlightedPinRelative(pin: Pin): string {
  return dayjs(pin.timestamp * 1000).fromNow();
}

function fixAgeRelative(diff: number): string {
  return dayjs.duration(diff, 'seconds').format('HH:mm:ss');
}

function timestampToHuman(timestamp: number) {
  return new Date(timestamp * 1000).toLocaleString();
}

interface HighlightedPinSignature {
  Args: {
    pins: Pin[];
    layers: any;
  };
  Element: HTMLDivElement;
}

export default class HighlightedPin extends Component<HighlightedPinSignature> {
  @service declare settings: SettingsService;

  autoPanPadding = new Point(50, 50);
  <template>
    {{#let
      (pickHighlightedPin this.args.pins this.settings.highlightedPin)
      as |pin|
    }}
      {{#if pin}}
        <@layers.marker
          @lat={{pin.latitude}}
          @lng={{pin.longitude}}
          @icon={{pinHighlighted}}
          as |marker|
        >
          <marker.popup
            @popupOpen='true'
            @autoPanPadding={{this.autoPanPadding}}
          >
            <ul>
              <li>
                <HeroIcon class='h-4 inline mr-1' @icon='calendar' />
                {{timestampToHuman pin.timestamp}}
              </li>
              <li>
                <HeroIcon class='h-4 inline mr-1' @icon='clock' />
                {{highlightedPinRelative pin}}
              </li>
              <li>
                <HeroIcon class='h-4 inline mr-1' @icon='magnifying-glass' />
                {{t
                  'map.accuracy'
                  value=(formatNumber
                    pin.accuracy
                    style='unit'
                    unit='meter'
                    maximumFractionDigits=0
                  )
                }}
              </li>
              <li>
                <HeroIcon class='h-4 inline mr-1' @icon='arrow-trending-up' />
                {{formatNumber
                  pin.altitude
                  style='unit'
                  unit='meter'
                  maximumFractionDigits=0
                }}
              </li>
              <li>
                <HeroIcon class='h-4 inline mr-1' @icon='battery-50' />
                {{formatNumber
                  pin.battery
                  style='unit'
                  unit='percent'
                  maximumFractionDigits=0
                }}
              </li>
              <li>
                <HeroIcon class='h-4 inline mr-1' @icon='forward' />
                {{formatNumber
                  pin.velocity
                  style='unit'
                  unit='kilometer-per-hour'
                  maximumFractionDigits=0
                }}
              </li>
              <li>
                <HeroIcon class='h-4 inline mr-1' @icon='arrows-pointing-in' />
                {{fixAgeRelative pin.fixAge}}
              </li>
            </ul>
          </marker.popup>
        </@layers.marker>

        {{#if this.settings.isAccuracyVisible}}
          <@layers.circle
            @lat={{pin.latitude}}
            @lng={{pin.longitude}}
            @radius={{pin.accuracy}}
          />
        {{/if}}
      {{/if}}
    {{/let}}
  </template>
}
