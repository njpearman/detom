require "detom/local_config"

describe Detom::LocalConfig do
  describe "a dynamic setter" do
    it do
      config = described_class.new
      config.client = "a value"
      expect(config.client).to eq "a value"
    end
  end
end
