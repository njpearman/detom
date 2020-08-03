require "yaml"

class JsonFileStore
  DEFAULT_APP_DIRECTORY = File.join Dir.home, ".detom"
    
  def initialize(filepath=DEFAULT_APP_DIRECTORY)
    @store = {}
    @filepath = filepath
  end

  def path
    @filepath
  end
  
  def [](key)
    @store[key]
  end

  def []=(key, value)
    @store[key] = value
  end

  def save!
    prepare!

    Dir.chdir(@filepath) do
      @store.each do |key, value|
        File.open(File.join(@filepath, key), "w") {|f| YAML.dump(@store[key], f) }
      end
    end
  end

  def prepare!
    create_root_directory unless root_directory_exists?
  end

  private
    def root_directory_exists?
      Dir.exist? DEFAULT_APP_DIRECTORY
    end

    def create_root_directory
      Dir.mkdir DEFAULT_APP_DIRECTORY
    end
end
