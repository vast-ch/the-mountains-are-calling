import {
  type Handler,
  type NextFn,
  type RequestContext,
} from '@ember-data/request';
import type { Point } from 'the-mountains-are-calling/services/settings';

export interface Response {
  content: Location;
}

interface Location {
  results: Point[];
}

const FirebaseHandler: Handler = {
  async request<T>(context: RequestContext, next: NextFn<T>) {
    if (context.request.op !== 'firebase') return next(context.request);

    try {
      const { content } = (await next(context.request)) as Response;

      return content as T;
    } catch (e) {
      console.log('FirebaseHandler.request().catch()', { e });
      throw e;
    }
  },
};

export default FirebaseHandler;
