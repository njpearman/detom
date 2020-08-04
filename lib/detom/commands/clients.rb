module Commands
  class Clients
    def initialize(store=YamlFileStore.new)
      @store = store
    end

    def call
      @store.each do |client, tracked_time|
        if tracked_time.nil?
          puts client
          next
        end

        total_time = tracked_time.map {|key, value| value.reduce(&:+) }.reduce &:+
        puts "#{client} #{total_time}m"
      end
    end
  end
end
