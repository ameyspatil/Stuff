# encode: ISO-8859-1
require "test/unit"
require "httparty"
require "json"
require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'

class CheckSite < Test::Unit::TestCase
  include HTTParty
  format :json
  def test_site
  	(0..9).each { |i| 
 		response = HTTParty.get("http://jobservice1.jibe.com:8080/jobs/all.json?status=active")
 		slug = response.parsed_response[i]['slug']
    description = "#{Jobservice.description(slug)}"
    description =description.gsub(/\r\n?/,"\n").force_encoding("UTF-8")
    title = "#{Jobservice.title(slug)}"
    title =title.gsub(/\r\n?/,"\n").force_encoding("UTF-8")
		source = HTTParty.get("http://www.jibe.com/jobs/#{slug}")		
		source = source.gsub(/<\/?[^>]*>/, "")
		source = source.gsub(/\r\n?/,"\n").gsub(/&quot;?/,"\"").force_encoding("UTF-8")
    assert(source.include?(description),"The description does not exists in the HTML with #{slug}")
    assert(source.include?(title),"The title does not exists in the HTML with #{slug}")
  	}	
  end

end
	
class Jobservice
  include HTTParty
  format :json  
  
 def self.title(slug)
    response = get "http://jobservice1.jibe.com:8080/jobs/slug/#{slug}.json"
    response.parsed_response[0]['title']
  end

  def self.description(slug)
  	response = get "http://jobservice1.jibe.com:8080/jobs/slug/#{slug}.json"
    response.parsed_response[0]['full_description']
  end	
end

