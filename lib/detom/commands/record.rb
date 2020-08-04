module Commands
  class Record
    def initialize(store)
      @store = store
    end

    def call(client_name, time_to_log, day_month = nil)
      if day_month
        help_now! "Day/month is an unrecognised format. Use `%d-%m` format" unless day_month =~ /\d\d-\d\d/

        day = day_month.split("-").first
        month = day_month.split("-").last
        
        # parse
        day_month = [Time.now.year.to_s, month, day].join "-"
      else
        day_month = Time.now.strftime("%Y-%m-%d")
      end

      @store[client_name] = {} if @store[client_name].nil?

      client = @store[client_name]

      if client[day_month]
        client[day_month] << time_to_log.to_i
      else
        client[day_month] = [ time_to_log.to_i ]
      end

      @store.save!
      puts "Logged #{time_to_log} for #{client_name}"
    end
  end
end

