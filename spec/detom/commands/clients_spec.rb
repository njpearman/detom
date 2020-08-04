require "detom/commands/clients"
require "detom/yaml_file_store"

RSpec.describe Commands::Clients do
  describe "#call" do
    context "for app directory setup" do
      subject { described_class.new.call }

      let(:dir) { class_double("Dir").as_stubbed_const }
      let!(:expected_directory) { File.join(Dir.home, ".detom") }

      def stub_app_directory
        dir = class_double("Dir").as_stubbed_const

        expect(dir).to receive(:exist?).with(expected_directory).and_return true
        expect(dir).to_not receive(:mkdir).with expected_directory
        expect(dir).to receive(:chdir).with(YamlFileStore::DEFAULT_APP_DIRECTORY)
      end

      it "creates the app directory in ~/.detom if it does not already exist" do
        expect(dir).to receive(:exist?).with(expected_directory).and_return false
        expect(dir).to receive(:mkdir).times.with expected_directory

        expect { subject }.to output("").to_stdout
      end

      it "does not create app directory if ~/.detom/ already exists" do
        stub_app_directory
        expect { subject }.to output("").to_stdout
      end
    end

    context "with a stubbed DEFAULT_APP_DIRECTORY" do
      class StubStore < YamlFileStore
        def initialize(clients)
          @store = clients
        end
      end

      subject { -> { described_class.new(StubStore.new(clients)).call } }

      context "with one empty client file" do
        let(:clients) { %w(foo_client) }

        it { is_expected.to output("foo_client\n").to_stdout }
      end

      context "with one client file tracking time" do
        let(:clients) { {"foo_client" => { "2020-07-29" => [30, 63] } } }

        it { is_expected.to output("foo_client 93m\n").to_stdout }
      end

      context "with more than one empty client file" do
        let(:clients) { %w(foo_client rii_client suu_client) }

        it { is_expected.to output("foo_client\nrii_client\nsuu_client\n").to_stdout }
      end

      context "with unordered empty client file" do
        let(:clients) { %w(rii_client foo_client baa_client suu_client) }

        it { is_expected.to output("baa_client\nfoo_client\nrii_client\nsuu_client\n").to_stdout }
      end
    end
  end
end
