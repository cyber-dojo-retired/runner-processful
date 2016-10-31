require_relative './lib_test_base'
# NB: if you call this file app_test.rb then SimpleCov fails to see it?!

class RunnerAppTest < LibTestBase

  def self.hex_prefix; '201BCEF'; end
  def hex_setup; new_avatar; end
  def hex_teardown; old_avatar; end

  test '348',
  'red-traffic-light' do
    runner_run(files)
    assert_equal completed, status
    assert stderr.start_with?('Assertion failed: answer() == 42'), json
    assert_equal '', stdout, json
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '16F',
  'green-traffic-light' do
    file_sub('hiker.c', '6 * 9', '6 * 7')
    runner_run(files)
    assert_equal completed, status, json
    assert_equal "All tests passed\n", stdout, json
    assert_equal '', stderr, json
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '295',
  'amber-traffic-light' do
    file_sub('hiker.c', '6 * 9', '6 * 9sss')
    runner_run(files)
    assert_equal completed, status, json
    lines = [
      "invalid suffix \"sss\" on integer constant",
      'return 6 * 9sss'
    ]
    lines.each { |line| assert stderr.include?(line), json }
    assert_equal '', stdout, json
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E6F',
  'timed-out-traffic-light' do
    file_sub('hiker.c', 'return', 'for(;;); return')
    runner_run(files, 3)
    assert_equal timed_out, status, json
    assert_equal '', stdout, json
    assert_equal '', stderr, json
  end

  private

  def new_avatar
    @json = runner.new_avatar(kata_id, avatar_name)
  end

  def old_avatar
    @json = runner.old_avatar(kata_id, avatar_name)
  end

  def runner_run(changed_files, max_seconds = 10)
    @json = runner.run(image_name, kata_id, avatar_name, max_seconds, deleted_filenames, changed_files)
  end

  def runner
    @runner ||= RunnerServiceAdapter.new
  end

  def json; @json; end
  def status; json['status']; end
  def stdout; json['stdout']; end
  def stderr; json['stderr']; end

  def image_name; 'cyberdojofoundation/gcc_assert'; end
  def kata_id; test_id; end
  def avatar_name; 'salmon'; end
  def deleted_filenames; []; end

  def files; @files ||= read_files; end
  def read_files
    filenames =%w( hiker.c hiker.h hiker.tests.c cyber-dojo.sh makefile )
    Hash[filenames.collect { |filename|
      [filename, IO.read("/app/start_files/gcc_assert/#{filename}")]
    }]
  end

  def file_sub(name, from, to)
    files[name] = files[name].sub(from, to)
  end

  def completed;   0; end
  def timed_out; 128; end

end
