require 'yaml'

module Detom
  class LocalConfig
    def load!
      return if @store

      if Dir.exist? ".detom"
        raise "Found .detom but it is a directory. Are you running `detom set` in your home directory?\n`detom set` should be run in the root of a project folder"
      end

      if File.exist? ".detom"
        @store = YAML.load File.read(".detom")
      else
        @store = {}
      end
    end

    def load_from!(config)
      @store ||= {}
      @store.merge! config
    end

    def save!
      @store.keys.each {|key| @store.delete(key) if @store[key].nil? }

      File.open(".detom", "w") {|file| file.write YAML.dump(@store) }
      puts "New config: #{@store}"
    end

    def method_missing(name, *args, &block)
      super unless handle?(name)

      handle(name, *args)
    end

    private
      def handle?(name)
        %i(client client= project=).include? name
      end

      def handle(name, *args)
        self.load!

        setter_match = name.match /(.*)=\B/

        if setter_match && setter_match[1]
          @store[setter_match[1].to_sym] = args.shift
        else
          @store[name]
        end
      end
  end
end
