module Commands
  class Record
    CLIENT_REQUIRED_MESSAGE = "Cannot log time without a client. Either provide <client> to detom record, or configure a value for client in this directory using detom set."
    DATE_FORMAT_MESSAGE = "Day/month is an unrecognised format. Use `%d-%m` format"
    TIME_TO_LOG_FORMAT_MESSAGE = "Time must be provided in minutes or hours, e,g 40m or 3h"

    def initialize(store, local_config)
      @store = store
      @local_config = local_config
    end

    def call(time_to_log, client_name=nil, day_month=nil)
      client = client_for client_name

      date_stamp = format(day_month)
  
      client[date_stamp] = [] unless client[date_stamp]

      client[date_stamp] << minutes_from(time_to_log)

      @store.save!
      $stdout.puts "Logged #{time_to_log} for #{client_name}"
    end

    private
    def format(day_month)
      return Time.now.strftime("%Y-%m-%d") if day_month.nil?

      raise DATE_FORMAT_MESSAGE unless day_month =~ /\d\d-\d\d/

      splits = day_month.split "-"
      [Time.now.year.to_s,  splits.last, splits.first].join "-"
    end

    def client_for(client_name)
      raise CLIENT_REQUIRED_MESSAGE if client_name.nil? && @local_config.client.nil?

      client_name = client_name || @local_config.client 

      @store[client_name] = {} if @store[client_name].nil?

      @store[client_name]
    end

    def minutes_from(time_to_log)
      multiplier = case time_to_log
        when /\d+m/ then 1
        when /\d+h/ then 60
        else raise TIME_TO_LOG_FORMAT_MESSAGE
      end

      multiplier * time_to_log.to_i
    end
  end
end
