require "detom/commands/record"
require "detom/yaml_file_store"

describe Commands::Record do
  subject { described_class.new(store, local_config) }
  let(:store) { YamlFileStore.new(test_filepath) }
  let(:local_config) { Detom::LocalConfig.new }

  describe "#call" do
    let(:test_filepath) { File.join(File.dirname(__FILE__), "..", "..", "..", "tmp", "record_test") }
    let(:today) { Time.now.strftime("%Y-%m-%d") }

    before { Dir.mkdir test_filepath unless Dir.exists? test_filepath }
    after { FileUtils.rm_rf test_filepath if Dir.exists? test_filepath }

    context "when recording time today" do
      context "for project with a configured client" do
        before { local_config.load_from! client: "faa" }

        it do
          subject.call("12m")
          expect(store["faa"]).to eq({ today => [12] })
        end

        context "and explicitly providing a client" do
          it do
            subject.call("50m", "bloo")
            expect(store["bloo"]).to eq({ today => [50] })
            expect(store["faa"]).to be_nil
          end
        end
      end

      context "once for one client" do
        it "stores the time spent on the client" do
          subject.call("6m", "foo_client")
          expect(store["foo_client"]).to eq({ today => [6] })
          expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{today}':
- 6
JSON
        end
      end

      context "twice for one client" do
        it "stores the time spent on the client" do
          subject.call("6m", "foo_client")
          subject.call("39m", "foo_client")
          expect(store["foo_client"]).to eq({ today => [6, 39] })
          expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{today}':
- 6
- 39
JSON
        end
      end

      context "three times for one client" do
        it "stores the time spent on the client" do
          subject.call("6m", "foo_client")
          subject.call("39m", "foo_client")
          expect { subject.call("92m", "foo_client") }.to output("Logged 92m for foo_client\n").to_stdout
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

      context "once each for two clients" do
        it "stores the time spent on the clients" do
          record_command = described_class.new(store, local_config)
          record_command.call("6m", "foo_client")
          record_command.call("39m", "raa_client")
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

      context "once each for three clients" do
        it "stores the time spent on the clients" do
          subject.call("6m", "foo_client")
          subject.call("39m", "raa_client")
          subject.call("72m", "gii_client")
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

    context "when recording time for a day in the past" do
      let(:five_days_ago) { Time.now - (5 * 24 * 60 * 60) }
      let(:expected_formatted_date) { five_days_ago.strftime("%Y-%m-%d") }

      context "once for one client" do
        it "stores the time spent on the client" do
          subject.call("6m", "foo_client", five_days_ago.strftime("%d-%m"))
          expect(store["foo_client"]).to eq({ expected_formatted_date => [6] })
          expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{expected_formatted_date}':
- 6
JSON
        end
      end
    end

    context "when recording time for different days" do
      let(:five_days_ago) { Time.now - (5 * 24 * 60 * 60) }
      let(:ten_days_ago) { Time.now - (10 * 24 * 60 * 60) }
      let(:expected_formatted_date_1) { five_days_ago.strftime("%Y-%m-%d") }
      let(:expected_formatted_date_2) { ten_days_ago.strftime("%Y-%m-%d") }

      context "once for one client" do
        it "stores the time spent on the client" do
          subject.call("6m", "foo_client", five_days_ago.strftime("%d-%m"))
          subject.call("45m", "foo_client", ten_days_ago.strftime("%d-%m"))
          expect(store["foo_client"]).to eq({ expected_formatted_date_1 => [6], expected_formatted_date_2 => [45] })
          expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{expected_formatted_date_1}':
- 6
'#{expected_formatted_date_2}':
- 45
JSON
        end
      end
    end

    context "when recording additional time for one client" do
      let(:five_days_ago) { Time.now - (5 * 24 * 60 * 60) }
      let(:ten_days_ago) { Time.now - (10 * 24 * 60 * 60) }
      let(:expected_formatted_date_1) { five_days_ago.strftime("%Y-%m-%d") }
      let(:expected_formatted_date_2) { ten_days_ago.strftime("%Y-%m-%d") }

      context "once for one client" do
        it "stores the time spent on the client" do
          File.open(File.join(test_filepath, "foo_client"), "w") {|f| f.write YAML.dump(expected_formatted_date_1 => [6]) }
          subject.call("45m", "foo_client", ten_days_ago.strftime("%d-%m"))
          expect(store["foo_client"]).to eq({ expected_formatted_date_1 => [6], expected_formatted_date_2 => [45] })
          expect(File.read(File.join(test_filepath, "foo_client"))).to eq <<-JSON
---
'#{expected_formatted_date_1}':
- 6
'#{expected_formatted_date_2}':
- 45
JSON
        end
      end
    end
  end
end
