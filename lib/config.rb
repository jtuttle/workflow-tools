class Config
  PROJECT_DIR = `git rev-parse --show-toplevel`.strip
  PROJECT_FILE = "#{PROJECT_DIR}/.workflow-tools.yml"

  class << self
    def user
      @@user ||= Hashie::Mash.load(File.expand_path("../../config/config.yml", __FILE__))
    end
      
    def project
      @@project ||=
        if File.exists?(PROJECT_FILE)
          Hashie::Mash.load(PROJECT_FILE)
        else
          Hashie::Mash.new
        end    
    end
  end
end
