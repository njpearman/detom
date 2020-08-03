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
        client[today] << time_to_log
      else
        client[today] = [ time_to_log ]
      end
    end
  end
end

