require 'test_helper'
require 'minitest/autorun'

class MavenReleaseTest < Minitest::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::MavenRelease::VERSION
  end


end
