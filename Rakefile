require 'rake'

namespace :db do
    task :prepare do
        require 'datamapper'
        
        Dir.glob('lib/*') do |lib|
            require lib
        end
        
        @config = YAML.load_file('usesthis.yml')
        DataMapper.setup(:default, @config[:database])
    end
    
    desc 'Create the database tables.'
    task :migrate => :prepare do
        DataMapper.auto_migrate!
    end
    
    desc 'Upgrade the database tables.'
    task :upgrade => :prepare do
        DataMapper.auto_upgrade!
    end
end