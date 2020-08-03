require "yaml"

class JsonFileStore
  def initialize(filepath)
    @store = {}
    @filepath = filepath
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
end
