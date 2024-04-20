import { module, test } from 'qunit';
import { setupTest } from 'the-mountains-are-calling/tests/helpers';

module('Unit | Route | settings', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    const route = this.owner.lookup('route:settings');
    assert.ok(route);
  });
});
