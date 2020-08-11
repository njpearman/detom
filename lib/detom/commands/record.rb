module Commands
  class Record
    def initialize(store, local_config)
      @store = store
      @local_config = local_config
    end

    def call(time_to_log, client_name=nil, day_month=nil)
      if client_name.nil? && @local_config.client.nil?
        raise "Cannot log time without a client. Either provide <client> to detom record, or configure a value for client in this directory using detom set."
      end

      if day_month
        raise "Day/month is an unrecognised format. Use `%d-%m` format" unless day_month =~ /\d\d-\d\d/

        splits = day_month.split("-")
        day_month = [Time.now.year.to_s,  splits.last, splits.first].join "-"
      else
        day_month = Time.now.strftime("%Y-%m-%d")
      end
  
      client_name = client_name || @local_config.client 

      @store[client_name] = {} if @store[client_name].nil?

      client = @store[client_name]

      client[day_month] = [] unless client[day_month]

      client[day_month] << time_to_log.to_i

      @store.save!
      $stdout.puts "Logged #{time_to_log} for #{client_name}"
    end
  end
end
