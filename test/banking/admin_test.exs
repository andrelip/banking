defmodule Banking.AdminTest do
  use Banking.DataCase

  alias Banking.Admin

  @test_key "uj/mQfYOZ0mo4P0WQUqmxmO1ROM04b33rykJ+kovboeyeyppIP3+wDxxeTViXJZ4"

  test "#verify_admin_key" do
    assert Admin.verify_admin_key(@test_key) == true
    assert Admin.verify_admin_key(@test_key <> "abc") == false
  end
end
