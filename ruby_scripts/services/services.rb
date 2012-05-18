class JobServices
  include HTTParty
  format :json
  
  def self.job_by_id(id) #Done
    get "http://#{$job_service}/jobs/id/#{id}.json"
  end
  
  def self.job_by_slug(slug) #Done
    get "http://#{$job_service}/jobs/slug/#{slug}.json" 
  end
  
  def self.questions_for_a_job(slug,user_id) #Done
    get "http://#{$job_service}/jobs/slug/#{slug}/user/#{user_id}/questions.json"
  end

  def self.jobs_by_companyid(company_id) #Done
    get "http://#{$job_service}/jobs/all.json?company=#{company_id}"
  end
  
  def self.jobs_by_categoryid(category_id) #Done
    get "http://#{$job_service}/jobs/all.json?category=#{category_id}" 
  end
  
  def self.jobs_by_status(status) #Done
    get "http://#{$job_service}/jobs/all.json?status=#{status}"
  end

  def self.jobs_by_offset(offset) #Done
   	get "http://#{$job_service}/jobs/all.json?offset=#{offset}"
  end
  
  def self.jobs_by_limit(limit) #Done
    get "http://#{$job_service}/jobs/all.json?limit=#{limit}" 
  end
 
  def self.search_jobs_by_title_text(title_text) #Done
    get "http://#{$job_service}/jobs/search/title_text:#{title_text}/rows/10/start/0.json"
  end

  def self.similar_jobs_by_id(id)
    get "http://#{$job_service}/jobs/similar.json?id=#{id}"
  end
  
  def self.similar_jobs_by_slug(slug)
    get "http://#{$job_service}/jobs/similar.json?slug=#{slug}" 
  end
  
  def self.other_jobs_by_id(id)
    get "http://#{$job_service}/jobs/other.json?id=#{id}"
  end

  def self.other_jobs_by_slug(slug)
    get "http://#{$job_service}/jobs/other.json?slug=#{slug}"
  end  
end

class CompanyServices
  include HTTParty
  format :json
  
  def self.company_by_id(id) #Done
    get "http://#{$company_service}/companies/id/#{id}.json"
  end
  
  def self.company_by_name(name) #Done
    get "http://#{$company_service}/companies/name/#{name}.json" 
  end

  def self.companies_by_offset(offset) #Done
   	get "http://#{$company_service}/companies/all.json?offset=#{offset}"
  end
  
  def self.companies_by_limit(limit) #Done
    get "http://#{$company_service}/companies/all.json?limit=#{limit}" 
  end
	 
  def self.companies_by_sort(id_sort) #Done
    get "http://#{$company_service}/companies/all.json?sort=id:#{id_sort}" 
  end

  def self.insert_company(company_input) 
    post("http://#{$company_service}/companies", 
      :body => company_input.to_json,
      :headers => { 'Content-Type' => 'application/json' })  
  end

  def self.update_company_by_id(id, company_input) 
    post("http://#{$company_service}/companies/id/#{id}", 
      :body => company_input.to_json,
      :headers => { 'Content-Type' => 'application/json' })  
  end

  def self.update_company_by_name(name, company_input) 
    post("http://#{$company_service}/companies/id/#{name}", 
      :body => company_input.to_json,
      :headers => { 'Content-Type' => 'application/json' }) 
  end

  def self.companies_batch_read(data) 
    post("http://#{$company_service}/companies/batch/read", 
      :body => data.to_json, 
      :headers => { 'Content-Type' => 'application/json' })
  end

  def self.companies_batch_update(batch_data) 
    post("http://#{$company_service}/companies/batch/update", 
      :query => batch_update.to_json,
      :headers => { 'Content-Type' => 'application/json' })
  end
end

class Solr
  include HTTParty
  format :json

  def self.solr_title_text(text)
 	get("http://solrslave1.jibe.com:8984/solr/select", :query => { :q => "title_text:#{text}" , :wt => "json"})
  end

  def self.solr_similar(text)
 	get("http://solrslave1.jibe.com:8984/solr/select", :query => { :q => "title_text:#{text}" , :wt => "json"})
  end
end	