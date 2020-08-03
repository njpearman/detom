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
        record_command.call("foo_client", "6m")
        record_command.call("foo_client", "39m")
        expect(store["foo_client"]).to eq({ today => [6, 39] })
      end
    end

    context "when recording time spent thrice on a client" do
      let(:store) { Hash.new }

      it "stores the time spent on the client" do
        today = Time.now.strftime("%Y-%m-%d")
        record_command = described_class.new(store)
        record_command.call("foo_client", "6m")
        record_command.call("foo_client", "39m")
        expect { record_command.call("foo_client", "92m") }.to output("Logged 92m for foo_client\n").to_stdout
        expect(store["foo_client"]).to eq({ today => [6, 39, 92] })
      end
    end
  end
end
