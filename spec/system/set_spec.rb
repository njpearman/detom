require "open3"

describe "detom set" do
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

  context "when no args are provided" do
    let(:command) { "bundle exec ../bin/detom set" }
    let(:expected_stderr) do 
      <<ERR
Found .detom but it is a directory. Are you running `detom set` in your home directory?
`detom set` should be run in the root of a project folder
ERR
end

    before { %x(mkdir .detom) }

    it do
      expect(stderr).to eq expected_stderr
      expect(Dir.exist? ".detom").to be_truthy
    end
  end

  context "when a client is provided" do
    let(:command) { "bundle exec ../bin/detom set foo" }
    let(:expected_stdout) do
<<OUT
New config: {:client=>"foo"}
OUT
    end

    it do
      expect(stdout).to eq expected_stdout
      expect(File.exist? ".detom").to be_truthy
    end
  end

  context "when a client is provided and config already exists" do
    let(:command) { "bundle exec ../bin/detom set faa" }
    before { %x(bundle exec ../bin/detom set foo) }
    
    let(:expected_stdout) do
<<OUT
Previous config: {:client=>"foo"}
New config: {:client=>"faa"}
OUT
    end
    it do
      expect(stdout).to eq expected_stdout
      expect(File.exist? ".detom").to be_truthy
    end
  end
end
