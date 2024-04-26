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

      // Filtered data is returned unordered: When using the REST API, the filtered results are returned in an undefined order since JSON interpreters don't enforce any ordering. If the order of your data is important you should sort the results in your application after they are returned from Firebase.

      const sortedContent = Object.values(content).sort(
        (a, b) => a.timestamp - b.timestamp,
      );

      return sortedContent as T;
    } catch (e) {
      console.log('FirebaseHandler.request().catch()', { e });
      throw e;
    }
  },
};

export default FirebaseHandler;
