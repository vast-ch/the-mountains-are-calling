import Application from '@ember/application';
import Resolver from 'ember-resolver';
import loadInitializers from 'ember-load-initializers';
import config from 'the-mountains-are-calling/config/environment';
import './app.css';
// import { setBuildURLConfig } from '@ember-data/request-utils';

// setBuildURLConfig({
//   host: 'https://the-mountains-are-calling-default-rtdb.europe-west1.firebasedatabase.app',
//   namespace: undefined,
// });
import '@glint/environment-ember-loose';

export default class App extends Application {
  modulePrefix = config.modulePrefix;
  podModulePrefix = config.podModulePrefix;
  Resolver = Resolver;
}

loadInitializers(App, config.modulePrefix);
