$:.unshift '.'
require 'rubygems'
require 'mysql2'
require "httparty"
require "json"
require "services"
require 'yajl'


class Setup
	def self.allocate_values(env)
		if env == "stg"
			$job_service		="209.114.35.61:8080"
			$company_service	="companyservice1.jibe.com:8080"
			$u_env				="jibeqa:jibejibe1124@jibe.testbacon.com"
			$hostname			="mysqls-02.jibe.com"
			$databasename 		= 'jibe_production'
			$username     		= 'apatil'
			$password 			= '0by_5A=7OAPpum8V'
		elsif env == "prd"	
			$job_service		="jobservice1.jibe.com:8080"
			$company_service	="companyservice1.jibe.com:8080"
		  	$u_env				="www.jibe.com"
			$hostname			= "mysqls-04.jibe.com"
			$databasename 		= 'jibe_production'
			$username     		= 'readonly'
			$password 			= 'r3ad0nly1124'
		end
	end

	def self.get_test_data	
		file = File.open("test_data.json","r")
		parser = Yajl::Parser.new
		$data = parser.parse(file)
	end	
end		