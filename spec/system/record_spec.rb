require "open3"

describe "detom record" do
  subject { Open3.capture3(command) }

  let(:stdout) { subject[0] }
  let(:stderr) { subject[1] }

  before do
    @original_dir = Dir.pwd
    Dir.chdir File.join(File.dirname(__FILE__), "..", "..", "tmp")
    %x(rm -rf .detom)
  end

  after do
    Dir.chdir @original_dir
  end

  let(:command) { "bundle exec ../bin/detom record 90m" }
  let(:expected_stdout) do
    <<OUT
Logged 90m for foofoo
OUT
  end

  it do
    %x(bundle exec ../bin/detom set foofoo)

    expect(stdout).to eq expected_stdout
    expect(stderr).to eq ""
  end
end
