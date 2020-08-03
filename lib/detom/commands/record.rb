module Commands
  class Record
    def initialize(store)
      @store = store
    end

    def call(client_name, time_to_log)
      today = Time.now.strftime("%Y-%m-%d")
      @store[client_name] = {} if @store[client_name].nil?

      client = @store[client_name]

      if client[today]
        client[today] << time_to_log.to_i
      else
        client[today] = [ time_to_log.to_i ]
      end

      @store.save!
      puts "Logged #{time_to_log} for #{client_name}"
    end
  end
end

