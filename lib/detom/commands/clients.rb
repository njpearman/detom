module Commands
  class Clients
    DEFAULT_APP_DIRECTORY = "~/.detom"
    
    def initialize
    end

    def call
      create_root_directory unless root_directory_exists?

      Dir.chdir DEFAULT_APP_DIRECTORY do
        puts Dir["*"]
      end
    end

    private
      def root_directory_exists?
        Dir.exist? DEFAULT_APP_DIRECTORY
      end

      def create_root_directory
        Dir.mkdir DEFAULT_APP_DIRECTORY
      end
  end
end
