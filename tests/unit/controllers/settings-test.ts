import { module, test } from 'qunit';
import { setupTest } from 'the-mountains-are-calling/tests/helpers';

module('Unit | Controller | settings', function (hooks) {
  setupTest(hooks);

  // TODO: Replace this with your real tests.
  test('it exists', function (assert) {
    const controller = this.owner.lookup('controller:settings');
    assert.ok(controller);
  });
});
