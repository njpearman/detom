require "detom/commands/client"

describe Commands::Client do
  describe "#call" do
    subject { described_class.new(store).call(client_name) }

    let(:store) { {} }

    context "with a client that has no time logged" do
      let(:client_name) { "foo_client" }
      it do
        expect { subject }.to output("No time logged against foo_client\n").to_stdout
      end
    end

    context "with a client that has one entry today" do
      let(:client_name) { "foo_client" }

      let(:store) { { "foo_client" => { Time.now.strftime("%Y-%m-%d") => [50] } } }
      it do
        expected_output = <<OUT
#{Time.now.strftime("%Y-%m-%d")}: 50m
OUT
        expect { subject }.to output(expected_output).to_stdout
      end
    end
  end
end
