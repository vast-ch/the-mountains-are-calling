import Model, { attr } from '@ember-data/model';

// See: https://owntracks.org/booklet/tech/json/
export default class PinModel extends Model {
  @attr BSSID;
  @attr SSID;
  @attr _type;
  @attr acc; // Accuracy of the reported location in meters without unit (iOS,Android/integer/meters/optional)
  @attr alt;
  @attr batt;
  @attr bs;
  @attr conn;
  @attr created_at;
  @attr lat; // latitude (iOS,Android/float/degree/required)
  @attr lon; // longitude (iOS,Android/float/degree/required)
  @attr m;
  @attr tid;
  @attr topic;
  @attr tst; // UNIX epoch timestamp in seconds of the location fix (iOS,Android/integer/epoch/required)
  @attr vac;
  @attr vel;

  get accuracy() {
    return this.acc;
  }

  get latitude() {
    return this.lat;
  }

  get longitude() {
    return this.lon;
  }

  get timestamp() {
    return this.tst;
  }
}
