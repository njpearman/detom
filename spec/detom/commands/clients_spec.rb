require "detom/commands/clients"

RSpec.describe Commands::Clients do
  describe "#call" do
    it "creates the app directory in ~/.detom if it does not already exist" do
      dir = class_double("Dir").as_stubbed_const

      expect(dir).to receive(:exist?).with("~/.detom").and_return false
      expect(dir).to receive(:mkdir).with "~/.detom"

      expect(described_class.new.call).to be_nil
    end

    it "does not create app directory if ~/.detom/ already exists" do
      dir = class_double("Dir").as_stubbed_const

      expect(dir).to receive(:exist?).with("~/.detom").and_return true
      expect(dir).to_not receive(:mkdir).with "~/.detom"

      expect(described_class.new.call).to be_nil
    end
  end
end
