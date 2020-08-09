module Commands
  class Record
    def initialize(store, local_config)
      @store = store
      @local_config = local_config
    end

    def call(time_to_log, client_name=nil, day_month = nil)
      if client_name.nil? && @local_config.client.nil?
        raise "Cannot log time without a client. Either provide <client> to detom record, or configure a value for client in a directory using detom set."
      end

      if day_month
        raise "Day/month is an unrecognised format. Use `%d-%m` format" unless day_month =~ /\d\d-\d\d/

        day = day_month.split("-").first
        month = day_month.split("-").last
        
        # parse
        day_month = [Time.now.year.to_s, month, day].join "-"
      else
        day_month = Time.now.strftime("%Y-%m-%d")
      end

      client_name = @local_config.client || client_name

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

