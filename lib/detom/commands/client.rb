module Commands
  class Client
    def call(client_name)
      $stdout.puts "No time logged against #{client_name}"
    end
  end
end
