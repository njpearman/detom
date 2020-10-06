module Commands
  class Mark
    def call
      puts Time.now.strftime("%H:%M")
    end
  end
end
