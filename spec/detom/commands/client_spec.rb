require "detom/commands/client"

describe Commands::Client do
  describe "#call" do
    subject { described_class.new(store).call(client_name) }

    let(:store) { {} }
    let(:today) { Time.now.strftime("%Y-%m-%d") }

    context "with a nil client" do 
      let(:client_name) { nil }
      it do 
        expect { subject }.to raise_error Commands::Client::CLIENT_REQUIRED_MESSAGE
      end
    end

    context "with no client given" do 
      let(:client_name) { "" }
      it do 
        expect { subject }.to raise_error Commands::Client::CLIENT_REQUIRED_MESSAGE
      end
    end

    context "with a client that has no time logged" do
      let(:client_name) { "foo_client" }
      it do
        expect { subject }.to output("No time logged against foo_client\n").to_stdout
      end
    end

    context "with a client that has one entry today" do
      let(:client_name) { "foo_client" }

      let(:store) { { "foo_client" => { today => [50] } } }
      it do
        expected_output = <<OUT
#{today}: 50m
OUT
        expect { subject }.to output(expected_output).to_stdout
      end
    end

    context "with a client that has two entries today" do
      let(:client_name) { "foo_client" }

      let(:store) { { "foo_client" => { today => [50, 5] } } }
      it do
        expected_output = <<OUT
#{today}: 55m
OUT
        expect { subject }.to output(expected_output).to_stdout
      end
    end

    context "with a client that has two entries today and one in the past" do
      let(:client_name) { "foo_client" }
      let(:time_before) { (Time.now - (60*60*24*10)).strftime("%Y-%m-%d") }

      let(:store) { { "foo_client" => { today => [50, 5], time_before => [130] } } }
      it do
        expected_output = <<OUT
#{time_before}: 2h10m
#{today}: 55m
OUT
        expect { subject }.to output(expected_output).to_stdout
      end
    end
  end
end
