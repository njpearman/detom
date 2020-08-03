module Commands
  class Record
    def initialize(store)
      @store = store
    end

    def call(client_name, time_to_log)
      @store[client_name] = { Time.now.strftime("%Y-%m-%d") => time_to_log }
    end
  end
end

