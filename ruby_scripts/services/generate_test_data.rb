require 'rubygems'
require "httparty"
require 'mysql2'
require "json"

=begin
class JobServices
  include HTTParty
  format :json
  
  def self.jobs_by_limit(limit) #Done
    get "http://jobservice1.jibe.com:8080/jobs/all.json?limit=#{limit}"
  end
  def self.companies_by_limit(limit) #Done
    get "http://companyservice1.jibe.com:8080/companies/all.json?limit=#{limit}" 
  end
end
=end

$env =ARGV[0]

if $env == "stg"
	job_service			="209.114.35.61:8080"
	company_service		=""
	u_env				="jibeqa:jibejibe1124@jibe.testbacon.com"
	hostname			="jibe.testbacon.com"
	databasename 		= 'jibe_staging'
	username     		= 'toby'
	password 			= 'uLT9L5BsVxBQDpFJ'
elsif $env == "prd"	
	job_service			="jobservice1.jibe.com:8080"
	company_service		="companyservice1.jibe.com:8080"
  	u_env				="www.jibe.com"
	hostname			= "mysqls-04.jibe.com"#"174.143.141.119";
	databasename 		= 'jibe_production'
	username     		= 'readonly'
	password 			= 'r3ad0nly1124'
end

data = { "jobs" => 
				{"id" => [], "slug" => [], "title" => [], "nutshell_description" => [], "company_id" => [], "status" => ["deleted", "active", "filled", "pending"], "category_id" => [] },
		 "companies" =>	
		 		{"id" => [], "company_name" => [], "code" => [], "status" => [0,1,2,3,4]  },
		 "users" =>
		 		{"id" => [52416373,], "name" => ["Tom"], "email" => ['jibeqa@gmail.com']  },
		  "etc" =>
		  		{"limit" => [1,5,10,15,20,25,30,35], "offset" => [14,50,100,72,53,68,4,88], "sort" => ["asec","desc"]}		
		} 		

puts "Connecting to the Database\n"
con = Mysql2::Client.new(:host => hostname,:username => username,:password => password,:database => databasename)
puts "Successfully connected to the DB\n"

puts "Gathering test Job data from the DB\n"
response = con.query("select * from jobs 
					  group by company_id
					  limit 30")
rs=response.collect

rs.each { |rs|
	data["jobs"]["id"] << rs["id"]
	data["jobs"]["slug"] << rs["slug"] 
	data["jobs"]["title"] << rs["title"]
	data["jobs"]["nutshell_description"] << rs["nutshell_description"]
	data["jobs"]["company_id"] << rs["company_id"]
}

puts "Gathering test Company data from the DB\n"
response = con.query("select * from companies 
					  limit 30")
rs =response.collect

rs.each { |rs|
	data["companies"]["id"] << rs["id"]
	data["companies"]["company_name"] << rs["company_name"] 
	data["companies"]["code"] << rs["code"]
}

puts "Gathering test Job Category data from the DB\n"
response = con.query("select distinct id from job_categories
					  limit 19")
rs =response.collect

rs.each { |rs|
	data["jobs"]["category_id"] << rs["id"]
}

puts "Gathering test User data from the DB\n"
response = con.query("select * from users
					  where first_name is not NULL
					  and email <> \"\"
					  limit 20")
rs =response.collect

rs.each { |rs|
	data["users"]["id"] << rs["id"]
	data["users"]["name"] << rs["first_name"]
	data["users"]["email"] << rs["email"]
}


mf = File.new("test_data.json", "w+")
mf.puts data.to_json
