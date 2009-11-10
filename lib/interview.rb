#
#    this is usesthis.com, a sinatra application.
#    it is copyright (c) 2009 daniel bogan (d @ waferbaby, then a dot and a 'com')
#

require 'datamapper'
require 'dm-is-paginated'

class Interview
    include DataMapper::Resource
    
    is :paginated
    
    property :slug,         String, :key => true
    property :person,       String
    property :summary,      String, :length => 100
    property :credits,      String, :length => 80
    property :overview,     Text
    property :hardware,     Text
    property :software,     Text
    property :dream_setup,  Text    
    property :published_at, DateTime
    
    timestamps :at
    
    validates_is_unique :slug
    validates_present :person, :summary, :overview, :hardware, :software, :dream_setup
    
    has n, :wares, :through => Resource
    
    before :create, :link_to_wares
    before :update, :link_to_wares
    
    def link_to_wares
        [overview, hardware, software, dream_setup].each do |content|
            puts "Looking at #{content}..."
            
            links = content.scan(/\[([^\[\(\)]+)\]\[([a-z0-9\.\-]+)?\]/)
            if links.length > 0
                links.each do |link|
                    slug = link[1] ? link[1] : link[0].downcase
                
                    unless self.wares.first(:slug => slug)
                        ware = Ware.first(:slug => slug)
                        unless ware.nil?
                            self.wares << ware
                        end
                    end
                end
            end
        end
        
        true
    end
end