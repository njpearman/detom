module Commands
  class Set
    def initialize(local_config=Detom::LocalConfig.new)
      @local_config = local_config
    end

    def call(client, project=nil)
      @local_config.load!

      @local_config.client = client
      @local_config.project = project

      @local_config.save!
    end
  end
end
