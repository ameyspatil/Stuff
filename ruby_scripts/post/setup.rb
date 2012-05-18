$:.unshift '.'
require 'rubygems'
require 'mysql2'
require "httparty"
require 'yajl'


class Setup
	def self.allocate_values(env)
		if env == "stg"
			$job_service		="209.114.35.61:8080"
			$company_service	=""
			$u_env				="jibeqa:jibejibe1124@jibe.testbacon.com"
			$hostname			="jibe.testbacon.com"
			$databasename 		= 'jibe_staging'
			$username     		= 'toby'
			$password 			= 'uLT9L5BsVxBQDpFJ'
		elsif env == "prd"	
			$job_service		="jobservice1.jibe.com:8080"
			$company_service	="companyservice1.jibe.com:8080"
		  	$u_env				="www.jibe.com"
			$hostname			= "mysqls-04.jibe.com"#"174.143.141.119";
			$databasename 		= 'jibe_production'
			$username     		= 'readonly'
			$password 			= 'r3ad0nly1124'
		end
	end

		

	def self.server 
		if $args[0] == 'remote'
		  server = "remote"
		elsif $args[0] == 'local'
		  server = "local"
		else
		  STDERR.puts "Unknown server type, please enter \"remote\" or \"local\""
		  exit! 1
		end
	end
	
	def self.browser
		if $args[1] == 'firefox'
		  browser = ("firefox").to_sym
		elsif $args[1] == 'chrome'
		  browser = ("chrome").to_sym
		elsif $args[1] == 'ie'
		  browser = ("ie").to_sym
		else
		  STDERR.puts "Unknown browser type, please enter \"firefox\" or \"chrome\" or \"ie\""
		  exit! 1
		end
	end
	
	def self.env
		if $args[2] == 'stg'
		  baseurl = "http://jibepost.testbacon.com"
		elsif $args[2] == 'prd'
		  baseurl = "http://jibepost.jibe.com"
		else
		  STDERR.puts "Unknown env type, please enter \"prd\" or \"stg\""
		  exit! 1
		end
	end


end		




