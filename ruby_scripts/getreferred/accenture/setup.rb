$:.unshift '.'
require 'rubygems'
require 'mysql2'
require "httparty"
require "json"

class Setup
	def self.initial_values
		if $args[2] == "stg"
			$base_url			="http://accenture.jibe.com"
			$job_url			="?job_id=0074865&job_name=Front-end%20Engineer&origin=http://careers.accenture.com"
			$job_title			="Front-end Engineer"
			$email				="shampatel113@gmail.com"
			$password			="jibejibe1124"
			return $base_url
		elsif $args[2] == "prd"	
			$base_url			="http://careers.accenture.com/"
			$job_url			="us-en/jobs/Pages/jobdetails.aspx?lang=en&job=00155444"
			$job_title			="Project Analyst"
			$email				="shampatel113@gmail.com"
			$password			="jibejibe1124"
			return $base_url
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
end		