require 'yaml'

module Detom
  class LocalConfig
    def load!
      if Dir.exist? ".detom"
        raise "Found .detom but it is a directory. Are you running `detom set` in your home directory?\n`detom set` should be run in the root of a project folder"
      end

      if File.exist? ".detom"
        @store = YAML.load File.read(".detom")
        puts "Previous config: #{@store}"
      else
        @store = {}
      end
    end

    def save!
      @store.keys.each do |key|
        if @store[key].nil?
          @store.delete key
        end
      end

      File.open(".detom", "w") {|file| file.write YAML.dump(@store) }
      puts "New config: #{@store}"
    end

    def client=(value)
      @store[:client] = value
    end

    def project=(value)
      @store[:project] = value
    end

    def method_missing(name, *args, &block)
      super unless handle?(name)

      handle(name)
    end

    private
      def handle?(name)
        name == :client
      end

      def handle(name)
        self.load!
        @store[name]
      end
  end
end
