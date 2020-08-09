require 'yaml'

module Commands
  class Set
    def initialize
    end

    def call(client, project=nil)
      if Dir.exist? ".detom"
        $stderr.puts "Found .detom but it is a directory. Are you running `detom set` in your home directory?\n`detom set` should be run in the root of a project folder"
        return
      end

      if File.exist? ".detom"
        local_config = YAML.load File.read(".detom")
        puts "Previous config: #{local_config}"
      else
        local_config = {}
      end

      local_config[:client] = client
      if project
        local_config[:project] = project
      else
        local_config.delete :project
      end


      File.open(".detom", "w") {|file| file.write YAML.dump(local_config) }
      puts "New config: #{local_config}"
    end
  end
end
