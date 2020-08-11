module Commands
  class Client
    def initialize(store)
      @store = store
    end

    def call(client_name)
      client = @store[client_name]

      if client
        output = client.sort.map do |day, times|
          "#{day}: #{format times}"
        end.join "\n"
        $stdout.puts output
      else
        $stdout.puts "No time logged against #{client_name}" 
      end
    end

    private 
    def format(times)
      total_time = times.inject(0, &:+)

      parts = []
      hours = (total_time / 60).floor
      parts << "#{hours}h" if hours > 0

      minutes = total_time % 60
      parts << "#{minutes}m" if minutes > 0

      parts.join
    end
  end
end
