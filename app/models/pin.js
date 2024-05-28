import Model, { attr } from '@ember-data/model';

export default class PinModel extends Model {
  @attr accuracy;
  @attr latitude;
  @attr longitude;
  @attr timestamp;
}
