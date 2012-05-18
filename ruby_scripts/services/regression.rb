$:.unshift '.'
require 'rubygems'
require 'mysql2'
require "httparty"
gem 'test-unit'
require "httparty"
require "json"


require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'
require "test/unit"
require 'yajl'
require 'setup'
require 'services'

$env =ARGV[0]

class JobServiceRegression < Test::Unit::TestCase
	Setup.get_test_data
	def self.startup
		if ($env)
			Setup.allocate_values($env)
		else
			puts "Please send stg/prd as command line parameter"
		end	
		begin
			@@con = Mysql2::Client.new(:host => $hostname,:username => $username,:password => $password,:database => $databasename)
			#puts results.collect(&:to_s) 
		rescue MysqlError => e
			print "Error code: ", e.errno, "\n"
			print "Error message: ", e.error, "\n"
		end
		#TestData.generate
    end

    def setup 
    end

	def test_connection
		rs = @@con.query('select * from users limit 1')
	end

    (0..($data["jobs"]["id"].size-1)).each do |i|
        define_method :"test_job_by_id_#{$data["jobs"]["id"][i]}" do
			id = $data["jobs"]["id"][i]
			job = JobServices.job_by_id(id)
			response = @@con.query("select * from jobs where id = #{id}")
			rs=response.collect { |a| a }
			assert_match(job[0]['title'],rs[0]['title'],"The title values are equal for #{$data["jobs"]["id"][i]}")
			assert_match(job[0]['slug'],rs[0]['slug'],"The slug values are equal for #{$data["jobs"]["id"][i]}")
			assert_match(job[0]['full_description'],rs[0]['full_description'],"The full-desc values are equal for #{$data["jobs"]["id"][i]}")
			assert_match(job[0]['status'],rs[0]['status'],"The status values are equal for #{$data["jobs"]["id"][i]}")
		end	
	end	

	(0..($data["jobs"]["slug"].size-1)).each do |i|
        define_method :"test_job_by_slug_#{i}" do
			slug = $data["jobs"]["slug"][i]
			job = JobServices.job_by_slug(slug)
			response = @@con.query("select * from jobs where slug =\"#{slug}\"")
			rs=response.collect { |a| a }
			assert_match(job[0]['title'],rs[0]['title'],"The title values are equal for #{$data["jobs"]["slug"][i]}")
			assert_match(job[0]['slug'],rs[0]['slug'],"The slug values are equal for #{$data["jobs"]["slug"][i]}")
			assert_match(job[0]['full_description'],rs[0]['full_description'],"The full-desc values are equal for #{$data["jobs"]["slug"][i]}")
			assert_match(job[0]['status'],rs[0]['status'],"The status values are equal for #{$data["jobs"]["slug"][i]}")
		end	
	end

	def test_questions_for_a_job #Known issues, should be improved
		slug = "senior-designer-amazon-prime-member-acquisition-amazon-seattle-wa"
		user_id = 52416373
		questions = JobServices.questions_for_a_job(slug,user_id)
		response = @@con.query("select a.id, a.company_persistent_question_id, a.value, a.identifier, q.company_id 
								from jobs j  
								inner join company_persistent_questions q 
								on j.company_id = q.company_id 
								inner join company_persistent_question_answers a 
								on a.company_persistent_question_id = q.id 
								where j.slug = \"#{slug}\" 
								and a.user_id = \"#{user_id}\"
								group by a.company_persistent_question_id
								order by a.company_persistent_question_id")
		rs=response.collect { |a| a }
		(0..((questions[0]['questions'].size) - 1)).each do |i|	
			assert( (questions[0]['questions'][i] =~ /#{rs[i]['value']}?/i),"The \"#{rs[i]['value']}\" answer is not seen for question #{i}")
			assert( (questions[0]['questions'][i] =~ /#{rs[i]['identifier']}?/i),"The \"#{rs[i]['identifier']}\" value is not seen for question #{i}")
		end
	end


	(0..($data["jobs"]["company_id"].size-1)).each do |i|
        define_method :"test_jobs_by_company_id_#{i}" do
			company_id =$data["jobs"]["company_id"][i]
			job = JobServices.jobs_by_companyid(company_id)
			response = @@con.query("select * from jobs where company_id=#{company_id} order by id limit 10")
			rs=response.collect { |a| a }
			(0..(job.size)-1).each do |i|	
				assert_match(job[i]['title'],rs[i]['title'],"The title values are equal for #{$data["jobs"]["company_id"][i]}")
				assert_match(job[i]['slug'],rs[i]['slug'],"The slug values are equal for #{$data["jobs"]["company_id"][i]}")
				assert_match(job[i]['full_description'],rs[i]['full_description'],"The full-desc values are equal for #{$data["jobs"]["company_id"][i]}")
				assert_match(job[i]['status'],rs[i]['status'],"The status values are equal for #{$data["jobs"]["company_id"][i]}")
			end
		end		
	end

	(0..($data["jobs"]["category_id"].size-1)).each do |i|
        define_method :"test_job_by_categoryid_#{$data["jobs"]["category_id"][i]}" do
			category_id = $data["jobs"]["category_id"][i]
			job = JobServices.jobs_by_categoryid(category_id)
			response = @@con.query("select * from jobs j
									left join job_categories_jobs jcj
									on j.id=jcj.job_id
									where jcj.job_category_id=#{category_id}
									group by j.id
									limit 10")
			rs=response.collect { |a| a }
			(0..(job.size)-1).each do |i|	
				assert_match(job[i]['title'],rs[i]['title'],"The title values are equal for #{$data["jobs"]["category_id"][i]}")
				assert_match(job[i]['slug'],rs[i]['slug'],"The slug values are equal for #{$data["jobs"]["category_id"][i]}")
				assert_match(job[i]['full_description'],rs[i]['full_description'],"The full-desc values are equal for #{$data["jobs"]["category_id"][i]}")
				assert_match(job[i]['status'],rs[i]['status'],"The status values are equal for #{$data["jobs"]["category_id"][i]}")
			end
		end	
	end

	(0..($data["jobs"]["status"].size-1)).each do |i|
        define_method :"test_job_by_status_#{$data["jobs"]["status"][i]}" do
			status = $data["jobs"]["status"][i]
			job = JobServices.jobs_by_status(status)
			response = @@con.query("select * from jobs 
									where status = '#{status}'
									order by id
									limit 10")
			rs=response.collect { |a| a }
			(0..9).each do |i|	
				assert_match(job[i]['title'],rs[i]['title'],"The title values are equal for #{$data["jobs"]["status"][i]}")
				assert_match(job[i]['slug'],rs[i]['slug'],"The slug values are equal for #{$data["jobs"]["status"][i]}")
				assert_match(job[i]['full_description'],rs[i]['full_description'],"The full-desc values are equal for #{$data["jobs"]["status"][i]}")
				assert_match(job[i]['status'],rs[i]['status'],"The status values are equal for #{$data["jobs"]["status"][i]}")
			end
		end	
	end

	(0..($data["etc"]["offset"].size-1)).each do |i|
        define_method :"test_job_by_offset_#{$data["etc"]["offset"][i]}" do
			offset = $data["etc"]["offset"][i]
			job = JobServices.jobs_by_offset(offset)
			response = @@con.query("select * from jobs 
									order by id
									limit #{offset},10")
			rs=response.collect { |a| a }
			(0..9).each do |i|	
				assert_match(job[i]['title'],rs[i]['title'],"The title values are equal for #{$data["etc"]["offset"][i]}")
				assert_match(job[i]['slug'],rs[i]['slug'],"The slug values are equal for #{$data["etc"]["offset"][i]}")
				assert_match(job[i]['full_description'],rs[i]['full_description'],"The full-desc values are equal for #{$data["etc"]["offset"][i]}")
				assert_match(job[i]['status'],rs[i]['status'],"The status values are equal for #{$data["etc"]["offset"][i]}")
			end
		end	
	end

	(0..($data["etc"]["limit"].size-1)).each do |i|
        define_method :"test_job_by_limit_#{$data["etc"]["limit"][i]}" do
			limit = $data["etc"]["limit"][i]
			job = JobServices.jobs_by_limit(limit)
			response = @@con.query("select * from jobs 
									order by id
									limit #{$data["etc"]["limit"][i]}")
			rs=response.collect { |a| a }
			(0..(([limit,25].min)-1)).each do |i|	
				assert_match(job[i]['title'],rs[i]['title'],"The title values are equal for #{$data["etc"]["limit"][i]}")
				assert_match(job[i]['slug'],rs[i]['slug'],"The slug values are equal for #{$data["etc"]["limit"][i]}")
				assert_match(job[i]['full_description'],rs[i]['full_description'],"The full-desc values are equal for #{$data["etc"]["limit"][i]}")
				assert_match(job[i]['status'],rs[i]['status'],"The status values are equal for #{$data["etc"]["limit"][i]}")
			end
		end	
	end

	def test_search_jobs_by_title_text #if this fails it is prolly because of %20 for spaces
		title_text = "HP"
		job = JobServices.search_jobs_by_title_text(title_text)
		solr_result = Solr.solr_title_text(title_text)
		(0..((solr_result['response']['docs'].size) - 1)).each do |i|
			assert_match(job['response']['docs'][i]['title_ss'],solr_result['response']['docs'][i]['title_ss'],"The title values are equal")
			assert_match(job['response']['docs'][i]['slug_ss'],solr_result['response']['docs'][i]['slug_ss'],"The slug values are equal")
			assert_match(job['response']['docs'][i]['id'],solr_result['response']['docs'][i]['id'],"The id values are equal")	
		end	
	end
=begin	
	#this needs to be done
	def test_similar_jobs_by_id
		job = JobServices.similar_jobs_by_id(1)
		response = @@con.query("select * from jobs 
								order by id
								limit 22")
		rs=response.collect { |a| a }
		(0..21).each do |i|	
			assert_match(job[i]['title'],rs[i]['title'],"The title values are equal")
			assert_match(job[i]['slug'],rs[i]['slug'],"The slug values are equal")
			assert_match(job[i]['full_description'],rs[i]['full_description'],"The full-desc values are equal")
			assert_match(job[i]['status'],rs[i]['status'],"The status values are equal")
		end	
	end
	#this needs to be done
	def test_similar_jobs_by_slug
		job = JobServices.similar_jobs_by_slug(22)
		response = @@con.query("select * from jobs 
								order by id
								limit 22")
		rs=response.collect { |a| a }
		(0..21).each do |i|	
			assert_match(job[i]['title'],rs[i]['title'],"The title values are equal")
			assert_match(job[i]['slug'],rs[i]['slug'],"The slug values are equal")
			assert_match(job[i]['full_description'],rs[i]['full_description'],"The full-desc values are equal")
			assert_match(job[i]['status'],rs[i]['status'],"The status values are equal")
		end	
	end
=end
	def teardown
    end

    def self.shutdown
        extend Test::Unit::Assertions
        @@con.close
    end 

end




class CompanyServiceRegression < Test::Unit::TestCase	
	Setup.get_test_data
	def self.startup
		Setup.allocate_values($env)
		begin
			@@con = Mysql2::Client.new(:host => $hostname,:username => $username,:password => $password,:database => $databasename)
			#puts results.collect(&:to_s) 
		rescue MysqlError => e
			print "Error code: ", e.errno, "\n"
			print "Error message: ", e.error, "\n"
		end
    end

	def test_connection
		rs = @@con.query('select * from users limit 1')
		#rs.each_hash { |h| puts h['email']}
	end

	(0..($data["companies"]["id"].size-1)).each do |i|
        define_method :"test_company_by_id_#{$data["companies"]["id"][i]}" do
			id = $data["companies"]["id"][i]
			job = CompanyServices.company_by_id(id)
			response = @@con.query("select * from companies where id = #{id}")
			rs=response.collect { |a| a }
			assert_equal(job[0]['id'],rs[0]['id'],"The company id values are equal for #{$data["companies"]["id"][i]}")
			assert_match(job[0]['company_name'],rs[0]['company_name'],"The company names values are equal for #{$data["companies"]["id"][i]}")
			assert_match(job[0]['code'],rs[0]['code'],"The company code values are equal for #{$data["companies"]["id"][i]}")
			assert_equal(job[0]['status'],rs[0]['status'],"The status values are equal for #{$data["companies"]["id"][i]}")
		end
	end	

	def test_company_by_name
		name = "Amazon"
		job = CompanyServices.company_by_name(name)
		response = @@con.query("select * from companies where company_name =\"#{name}\"")
		rs=response.collect { |a| a }
		assert_equal(job[0]['id'],rs[0]['id'],"The id values are equal")
		assert_match(job[0]['company_name'],rs[0]['company_name'],"The company_name values are equal")
		assert_match(job[0]['code'],rs[0]['code'],"The code values are equal")
		assert_equal(job[0]['status'],rs[0]['status'],"The status values are equal")
	end

	(0..($data["etc"]["offset"].size-1)).each do |i|
        define_method :"test_companies_by_offset_#{$data["etc"]["offset"][i]}" do
			offset = $data["etc"]["offset"][i]
			job = CompanyServices.companies_by_offset(offset)
			response = @@con.query("select * from companies
									order by id
									limit #{offset},10")
			rs=response.collect { |a| a }
			(0..9).each do |i|
				assert_equal(job[i]['id'],rs[i]['id'],"The company id values are equal for #{$data["etc"]["offset"][i]}")
				assert_match(job[i]['company_name'],rs[i]['company_name'],"The company names values are equal for #{$data["etc"]["offset"][i]}")
				assert_match(job[i]['code'],rs[i]['code'],"The company code values are equal for #{$data["etc"]["offset"][i]}")
				assert_equal(job[i]['status'],rs[i]['status'],"The status values are equal for #{$data["etc"]["offset"][i]}")
			end
		end
	end	

	(0..($data["etc"]["limit"].size-1)).each do |i|
        define_method :"test_companies_by_limit_#{$data["etc"]["limit"][i]}" do
			limit = $data["etc"]["limit"][i]
			job = CompanyServices.companies_by_limit(limit)
			response = @@con.query("select * from companies 
									order by id
									limit #{limit}")
			rs=response.collect { |a| a }
			(0..(([limit,25].min) - 1)).each do |i|
				assert_equal(job[i]['id'],rs[i]['id'],"The id values are equal for #{$data["etc"]["limit"][i]}")
				assert_match(job[i]['company_name'],rs[i]['company_name'],"The company_name values are equal for #{$data["etc"]["limit"][i]}")
				assert_match(job[i]['code'],rs[i]['code'],"The code values are equal for #{$data["etc"]["limit"][i]}")
				assert_equal(job[i]['status'],rs[i]['status'],"The status values are equal for #{$data["etc"]["limit"][i]}")
			end
		end	
	end

	def test_companies_by_sort
		id_sort="asc"
		title_sort = "desc"
		job = CompanyServices.companies_by_sort(id_sort)
		response = @@con.query("select * from companies 
								order by id #{id_sort}
								limit 22")
		rs=response.collect { |a| a }
		(0..21).each do |i|
			assert_equal(job[0]['id'],rs[0]['id'],"The id values are equal")
			assert_match(job[0]['company_name'],rs[0]['company_name'],"The company_name values are equal")
			assert_match(job[0]['code'],rs[0]['code'],"The code values are equal")
			assert_equal(job[0]['status'],rs[0]['status'],"The status values are equal")
		end	
	end

	def test_companies_batch_read
	    data = {
		    	:limiter_values => [[25,3], [9,3], [3,3], [11,3], [15,3]],
		    	:properties => ["name", "code"],
		    	:limiters => ["id", "status"]
	    		}
	    companies = CompanyServices.companies_batch_read(data)
	    response = @@con.query('select company_name, code from companies
							where id in (25,9,3,11,15)
							and status = 3')
		rs = response.collect
		(0..((rs.size)-1)).each do |i|
			assert_match(rs[i]['company_name'],companies[i]['company_name'],"The name matches")
			assert_match(rs[i]['code'],companies[i]['code'],"The code matches")
		end
	end	

	def teardown
    end

    def self.shutdown
        extend Test::Unit::Assertions
        @@con.close
    end 

end

