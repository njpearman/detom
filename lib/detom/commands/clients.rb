module Commands
  class Clients
    def initialize
    end

    def call
      store = JsonFileStore.new
      store.prepare!

      Dir.chdir store.path do
        puts Dir["*"]
      end
    end
  end
end
