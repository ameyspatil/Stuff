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
    id = response.parsed_response[i]['id']
 		description = "#{Jobservice.description(id)}"
		description =description.gsub(/\r\n?/,"\n").force_encoding("UTF-8")
    title = "#{Jobservice.title(id)}"
    title =title.gsub(/\r\n?/,"\n").force_encoding("UTF-8") 
		source = HTTParty.get("http://www.jibe.com/jobs/#{id}").gsub(/<\/?[^>]*>/, "").gsub(/\r\n?/,"\n").gsub(/&quot;?/,"\"").force_encoding("UTF-8")	
    assert(source.include?(description),"The description does not exists in the HTML with #{id}")
      #File.open('source.txt', 'w') {|f| f.write(source) }
      #File.open('json.txt', 'w') {|f| f.write(description) }  
    assert(source.include?(title),"The title does not exists in the HTML with #{id}")     
  }  
  end

end
	
class Jobservice
  include HTTParty
  format :json  
  
  def self.title(id)
    response = get "http://jobservice1.jibe.com:8080/jobs/id/#{id}.json"
    response.parsed_response[0]['title']
  end

  def self.description(id)
  	response = get "http://jobservice1.jibe.com:8080/jobs/id/#{id}.json"
    response.parsed_response[0]['full_description']
  end	
end

