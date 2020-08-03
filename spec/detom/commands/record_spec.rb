require "detom/commands/record"

describe Commands::Record do
  describe "#call" do
    let(:store) { Hash.new }

    it "does something" do
      today = Time.now.strftime("%Y-%m-%d")
      described_class.new(store).call("foo_client", "6m")
      expect(store["foo_client"]).to eq({ today => "6m" })
    end
  end
end
