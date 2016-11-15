require_relative './runner_test_base'
require_relative './mock_sheller'

class DockerRunnerPullMockShellerTest < RunnerTestBase

  def self.hex_prefix; '0D5'; end

  def shell; @shell ||= MockSheller.new(nil); end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9C3',
  'pulled?(image_name) is false' do
    image_name = 'cdf/ruby_mini_test'
    stdout = [
      'REPOSITORY     TAG    IMAGE ID     CREATED    SIZE',
      'cdf/gcc_assert latest 28683e525ad3 9 days ago 95.97 MB'
    ].join("\n")
    shell.mock_exec('docker images', stdout, '', 0)
    stdout,stderr,status = runner.pulled?(image_name)
    assert_equal '', stdout
    assert_equal '', stderr
    assert_equal false, status
    shell.teardown
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A44',
  'pulled?(image_name) is true' do
    image_name = 'cdf/ruby_mini_test'
    stdout = [
      'REPOSITORY     TAG    IMAGE ID     CREATED    SIZE',
      "#{image_name}  latest 28683e525ad3 9 days ago 95.97 MB"
    ].join("\n")
    shell.mock_exec('docker images', stdout, '', 0)
    stdout,stderr,status = runner.pulled?(image_name)
    assert_equal '', stdout
    assert_equal '', stderr
    assert_equal true, status
    shell.teardown
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '91C',
  'pull(image_name) issues unconditional docker-pull command' do
    image_name = 'cdf/ruby_mini_test'
    shell.mock_exec("docker pull #{image_name}", '', '', success)
    stdout,stderr,status = runner.pull(image_name)
    assert_equal '', stdout
    assert_equal '', stderr
    assert_equal success, status
    shell.teardown
  end

end

