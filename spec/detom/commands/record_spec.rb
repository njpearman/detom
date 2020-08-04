require "detom/commands/record"
require "detom/yaml_file_store"

describe Commands::Record do
  subject { described_class.new(store) }
  let(:store) { YamlFileStore.new(test_filepath) }

  describe "#call" do
    let(:test_filepath) { File.join(File.dirname(__FILE__), "..", "..", "..", "tmp", "record_test") }
    let(:today) { Time.now.strftime("%Y-%m-%d") }

    before { Dir.mkdir test_filepath unless Dir.exists? test_filepath }
    after { FileUtils.rm_rf test_filepath if Dir.exists? test_filepath }

    context "when recording time spent today on a client" do
      it "stores the time spent on the client" do
        subject.call("foo_client", "6m")
        expect(store["foo_client"]).to eq({ today => [6] })
        expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{today}':
- 6
JSON
      end
    end

    context "when recording time spent today twice on a client" do
      it "stores the time spent on the client" do
        subject.call("foo_client", "6m")
        subject.call("foo_client", "39m")
        expect(store["foo_client"]).to eq({ today => [6, 39] })
        expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{today}':
- 6
- 39
JSON
      end
    end

    context "when recording time spent today thrice on a client" do
      it "stores the time spent on the client" do
        subject.call("foo_client", "6m")
        subject.call("foo_client", "39m")
        expect { subject.call("foo_client", "92m") }.to output("Logged 92m for foo_client\n").to_stdout
        expect(store["foo_client"]).to eq({ today => [6, 39, 92] })
        expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{today}':
- 6
- 39
- 92
JSON
      end
    end

    context "when recording time spent today on two clients" do
      it "stores the time spent on the clients" do
        record_command = described_class.new(store)
        record_command.call("foo_client", "6m")
        record_command.call("raa_client", "39m")
        expect(store["foo_client"]).to eq({ today => [6] })
        expect(store["raa_client"]).to eq({ today => [39] })
        expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{today}':
- 6
JSON
        expect(File.read(File.join(test_filepath, "raa_client"))).to eq <<-JSON
---
'#{today}':
- 39
JSON
      end
    end

    context "when recording time spent today on three clients" do
      it "stores the time spent on the clients" do
        subject.call("foo_client", "6m")
        subject.call("raa_client", "39m")
        subject.call("gii_client", "72m")
        expect(store["foo_client"]).to eq({ today => [6] })
        expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{today}':
- 6
JSON
        expect(store["raa_client"]).to eq({ today => [39] })
        expect(File.read(File.join(test_filepath, "raa_client"))).to eq <<-JSON
---
'#{today}':
- 39
JSON
        expect(store["gii_client"]).to eq({ today => [72] })
        expect(File.read(File.join(test_filepath, "gii_client"))).to eq <<-JSON
---
'#{today}':
- 72
JSON
      end
    end
  end
end
