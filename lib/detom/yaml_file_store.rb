require "yaml"

class YamlFileStore
  DEFAULT_APP_DIRECTORY = File.join Dir.home, ".detom"
    
  def initialize(filepath=DEFAULT_APP_DIRECTORY)
    @store = {}
    @filepath = filepath
    prepare!
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
    Dir.chdir(@filepath) do
      @store.each do |key, value|
        File.open(File.join(@filepath, key), "w") {|f| YAML.dump(@store[key], f) }
      end
    end
  end

  def prepare!
    if root_directory_exists?
      # load files
      Dir.chdir(@filepath) do
        Dir["*"].each do |filename|
          @store[filename] = YAML.load File.read(File.join(@filepath, filename))
        end
      end
    else
      create_root_directory
    end
  end

  private
    def root_directory_exists?
      Dir.exist? @filepath
    end

    def create_root_directory
      Dir.mkdir @filepath
    end
end
