import Component from '@glimmer/component';
import type { Pin } from 'the-mountains-are-calling/services/settings';
//@ts-ignore No TS
import { divIcon } from 'ember-leaflet/helpers/div-icon';
import accuracyToColour from 'the-mountains-are-calling/helpers/accuracy-to-colour';

interface lastKnownPinSignature {
  Args: {
    pin: Pin | undefined;
    layers: any;
  };
  Element: HTMLDivElement;
}

export default class lastKnownPin extends Component<lastKnownPinSignature> {
  get pinLastKnown() {
    return divIcon([], {
      html: `      <?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" viewBox="0 0 210 297" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g><path d="m174.37 119.04a69.37 67.231 0 0 1-69.22 67.231 69.37 67.231 0 0 1-69.52-66.94 69.37 67.231 0 0 1 68.918-67.522 69.37 67.231 0 0 1 69.819 66.647" fill="#fff"/><path d="m101.25 259.27c-6.6855-6.9492-16.932-18.389-23.456-26.188-28.723-34.336-46.139-65.935-51.427-93.31-1.4458-7.4842-1.6259-9.5823-1.6198-18.874 0.0052-8.0066 0.10904-9.7466 0.81692-13.691 4.5803-25.526 20.521-46.756 43.627-58.104 18.828-9.2469 41.734-10.735 61.912-4.0233 24.712 8.2199 44.46 28.914 51.493 53.958 2.146 7.6427 2.6462 11.764 2.6527 21.861 6e-3 9.2913-0.17401 11.389-1.6198 18.874-6.5171 33.736-31.12 73.286-73.241 117.74-2.8037 2.9589-5.2227 5.3799-5.3756 5.3799s-1.8459-1.6298-3.7623-3.6217zm15.077-82.065c4.739-1.0327 8.3119-2.2648 12.909-4.4518 16.194-7.7037 27.43-22.386 31.044-40.566 0.96397-4.8497 0.86221-16.007-0.19062-20.902-2.4853-11.554-7.3342-20.491-15.553-28.669-6.8031-6.7682-13.45-10.886-22.161-13.729-6.3872-2.0845-10.173-2.6651-17.378-2.6651-7.181 0-10.992 0.58108-17.291 2.6368-8.6978 2.8382-15.5 7.0447-22.248 13.757-8.2193 8.1772-13.068 17.115-15.553 28.669-1.0528 4.8944-1.1546 16.052-0.19062 20.902 4.7146 23.719 22.266 41.057 45.934 45.376 4.9382 0.90105 15.759 0.71351 20.678-0.35838z" fill="${accuracyToColour(
        this.args.pin?.accuracy,
      )}" stroke="#000" stroke-linejoin="round" stroke-width="8.8426"/><text x="105" y="151.10283" fill="#000000" font-family="sans-serif" font-size="88.194px" stroke-width="8.8426" style="line-height:1.25" xml:space="preserve"><tspan x="105" y="151.10283" fill="#000000" font-size="88.194px" stroke-width="8.8426" text-align="center" text-anchor="middle">🦄</tspan></text></g></svg>





      `,
      iconSize: [32, 32],
      iconAnchor: [16, 38],
    });
  }

  <template>
    {{#let this.args.pin as |pin|}}
      {{#if pin}}
        <@layers.marker
          @zIndexOffset={{1020}}
          @lat={{pin.latitude}}
          @lng={{pin.longitude}}
          @icon={{this.pinLastKnown}}
        />
      {{/if}}
    {{/let}}
  </template>
}
