require "detom/commands/client"

describe Commands::Client do
  describe "#call" do
    it do
      expect { described_class.new.call "foo_client" }.to output("No time logged against foo_client\n").to_stdout

    end
  end
end
