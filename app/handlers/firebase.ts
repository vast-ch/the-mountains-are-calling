import {
  type Handler,
  type NextFn,
  type RequestContext,
} from '@ember-data/request';

export interface Response {
  content: Location;
}

interface Location {
  results: Result[];
}

interface Result {
  attrs: Attrs;
  id: number;
  weight: number;
}

interface Attrs {
  detail: string;
  featureId: string;
  geom_quadindex: string;
  geom_st_box2d: string;
  label: string;
  lat: number;
  lon: number;
  num: number;
  objectclass: string;
  origin: string;
  rank: number;
  x: number;
  y: number;
  zoomlevel: number;
}

export interface GeoModel extends Attrs {
  id: number;
  labelPlainText: string;
}

export interface GeoResponse {
  content: GeoModel[];
}

const FirebaseHandler: Handler = {
  async request<T>(context: RequestContext, next: NextFn<T>) {
    console.log({ context }, { next });
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
