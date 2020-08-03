require "detom/commands/record"

describe Commands::Record do
  describe "#call" do
    context "when recording time spent on a client" do
      let(:store) { Hash.new }

      it "stores the time spent on the client" do
        today = Time.now.strftime("%Y-%m-%d")
        described_class.new(store).call("foo_client", "6m")
        expect(store["foo_client"]).to eq({ today => [6] })
      end
    end

    context "when recording time spent twice on a client" do
      let(:store) { Hash.new }

      it "stores the time spent on the client" do
        today = Time.now.strftime("%Y-%m-%d")
        record_command = described_class.new(store)
        record_command.call("foo_client", 6)
        record_command.call("foo_client", 39)
        expect(store["foo_client"]).to eq({ today => [6, 39] })
      end
    end
  end
end
