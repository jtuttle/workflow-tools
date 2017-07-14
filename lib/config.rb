class Config
  CONFIG_DIR = 'config'
  PROJECT_DIR = `git rev-parse --show-toplevel`.strip

  User = Hashie::Mash.load("#{CONFIG_DIR}/config.yml")
end
