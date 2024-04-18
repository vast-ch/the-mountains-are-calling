import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import type { FormResultData } from '@frontile/forms';
import * as dayjs from 'dayjs';

export default class ApplicationController extends Controller {
  queryParams = ['deviceId', 'startDate', 'endDate'];

  @tracked deviceId = 'demo';
  @tracked startDate = dayjs().subtract(1, 'week').startOf('day').valueOf();
  @tracked endDate = dayjs().endOf('day').valueOf();

  @action onChange(data: FormResultData) {
    this.startDate = dayjs(data['startDate'] as string)
      .startOf('day')
      .valueOf();
    this.endDate = dayjs(data['endDate'] as string)
      .endOf('day')
      .valueOf();
    this.deviceId = data['deviceId'] as string;
  }
}
