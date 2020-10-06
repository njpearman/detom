module Commands
  class Mark
    def initialize
      @filepath = File.join YamlFileStore::DEFAULT_APP_DIRECTORY, ".marks"
    end

    def call(client)
      mark = Time.now
      # create mark file unless exists
      load_marks

      # set value for client
      @marks[client] = mark

      # replace contents of mark file
      File.open(@filepath, "w") {|file| YAML.dump @marks, file }

      STDOUT.puts "Marked #{client} at #{mark.strftime("%H:%M")}"
    end
    
    def clear(client)
      load_marks

      put_no_marks(client) && return unless marked?(client)
      
      @marks.delete client
      File.open(@filepath, "w") {|file| YAML.dump @marks, file }

      STDOUT.puts "Removed mark for #{client}"
    end

    def list
      load_marks

      if @marks.any?
        @marks.each do |mark|
          time = mark[1].strftime("%H:%M (%Y-%m-%d)")
          STDOUT.puts "#{mark[0]}: #{time}"
        end
      else
        STDOUT.puts "Nothing is currently marked"
      end
    end

    private
    def marked?(client)
      @marks.keys.include? client
    end

    def load_marks
      File.exist?(@filepath).tap do |exist|
        if exist
          @marks = YAML.load File.read(@filepath) 
        else
          @marks = {}
        end
      end
    end
    
    def puts_no_mark(client)
      STDOUT.puts "No mark set for #{client}"
    end
  end
end
