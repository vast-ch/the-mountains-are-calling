import { module, test } from 'qunit';
import { setupTest } from 'the-mountains-are-calling/tests/helpers';

module('Unit | Service | settings', function (hooks) {
  setupTest(hooks);

  // TODO: Replace this with your real tests.
  test('it exists', function (assert) {
    const service = this.owner.lookup('service:settings');
    assert.ok(service);
  });
});
