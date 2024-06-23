import Model, { attr } from '@ember-data/model';

// See: https://owntracks.org/booklet/tech/json/
export default class PinModel extends Model {
  @attr BSSID;
  @attr SSID;
  @attr _type;
  @attr acc; // Accuracy of the reported location in meters without unit (iOS,Android/integer/meters/optional)
  @attr alt; // Altitude measured above sea level (iOS,Android/integer/meters/optional)
  @attr batt; // Device battery level (iOS,Android/integer/percent/optional)
  @attr bs;
  @attr conn;
  @attr created_at; // identifies the time at which the message is constructed (vs. tst which is the timestamp of the GPS fix) (iOS,Android)
  @attr lat; // latitude (iOS,Android/float/degree/required)
  @attr lon; // longitude (iOS,Android/float/degree/required)
  @attr m;
  @attr tid;
  @attr topic;
  @attr tst; // UNIX epoch timestamp in seconds of the location fix (iOS,Android/integer/epoch/required)
  @attr vac;
  @attr vel; // velocity (iOS,Android/integer/kmh/optional)

  get accuracy() {
    return this.acc;
  }

  get altitude() {
    return this.alt;
  }

  get battery() {
    return this.batt;
  }

  get latitude() {
    return this.lat;
  }

  get longitude() {
    return this.lon;
  }

  get timestamp() {
    return this.created_at;
  }

  get velocity() {
    return this.vel;
  }

  get fixAge() {
    return this.created_at - this.tst;
  }
}
