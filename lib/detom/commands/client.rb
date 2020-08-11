module Commands
  class Client
    def initialize(store)
      @store = store
    end

    def call(client_name)
      client = @store[client_name]

      if client
        output = client.sort.map do |day, times|
          "#{day}: #{times.join}m"
        end.join "\n"
        $stdout.puts output
      else
        $stdout.puts "No time logged against #{client_name}" 
      end
    end
  end
end
