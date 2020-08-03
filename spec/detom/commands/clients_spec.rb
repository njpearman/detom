require "detom/commands/clients"

RSpec.describe Commands::Clients do
  describe "#call" do
    subject { described_class.new.call }

    context "for app directory setup" do
      let(:dir) { class_double("Dir").as_stubbed_const }

      def stub_app_directory
        dir = class_double("Dir").as_stubbed_const

        expect(dir).to receive(:exist?).with("~/.detom").and_return true
        expect(dir).to_not receive(:mkdir).with "~/.detom"
        expect(dir).to receive(:chdir).with(Commands::Clients::DEFAULT_APP_DIRECTORY)
      end

      it "creates the app directory in ~/.detom if it does not already exist" do
        expect(dir).to receive(:exist?).with("~/.detom").and_return false
        expect(dir).to receive(:mkdir).with "~/.detom"
        expect(dir).to receive(:chdir).with(Commands::Clients::DEFAULT_APP_DIRECTORY)

        expect { subject }.to output("").to_stdout
      end

      it "does not create app directory if ~/.detom/ already exists" do
        stub_app_directory
        expect { subject }.to output("").to_stdout
      end
    end

    context "with a stubbed DEFAULT_APP_DIRECTORY" do
      let(:test_project_root) { File.join(File.dirname(__FILE__), "..", "..", "..") }
      let(:test_app_folder) { File.join(test_project_root, "tmp", "detom") }

      before { stub_const "Commands::Clients::DEFAULT_APP_DIRECTORY", test_app_folder }
      after { FileUtils.rm_rf test_app_folder }

      context "with one client file in ~/.detom/clients" do
        before { FileUtils.mkdir_p File.join(test_app_folder, "foo_client") }

        it "lists one client" do
          expect { subject }.to output("foo_client\n").to_stdout
        end
      end
    end
  end
end
