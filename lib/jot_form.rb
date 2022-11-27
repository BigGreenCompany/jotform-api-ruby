#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'rubygems'
require 'json'

# TODO: move to github gem
class JotForm
  attr_accessor :api_key, :base_url, :api_version

  # Create the object
  def initialize(api_key = nil, base_url = 'http://api.jotform.com', api_version = 'v1')
    @api_key = api_key
    @base_url = base_url
    @api_version = api_version
  end

  def fetch_user
    execute_get_request('user')
  end

  def fetch_usage
    execute_get_request('user/usage')
  end

  def fetch_forms
    execute_get_request('user/forms')
  end

  def fetch_submissions
    execute_get_request('user/submissions')
  end

  def fetch_subusers
    execute_get_request('user/subusers')
  end

  def fetch_folders
    execute_get_request('user/folders')
  end

  def fetch_reports
    execute_get_request('user/reports')
  end

  def fetch_settings
    execute_get_request('user/settings')
  end

  def fetch_history
    execute_get_request('user/history')
  end

  def fetch_form(form_id)
    execute_get_request('form/' + form_id)
  end

  def fetch_form_questions(form_id)
    execute_get_request('form/' + form_id + '/questions')
  end

  def fetch_form_question(form_id, qid)
    execute_get_request('form/' + form_id + '/question/' + qid)
  end

  def fetch_form_properties(form_id)
    execute_get_request('form/' + form_id + '/properties')
  end

  def fetch_form_property(form_id, property_key)
    execute_get_request('form/' + form_id + '/properties/' + property_key)
  end

  def fetch_form_submissions(form_id)
    execute_get_request('form/' + form_id + '/submissions')
  end

  def fetch_form_files(form_id)
    execute_get_request('form/' + form_id + '/files')
  end

  def fetch_form_webhooks(form_id)
    execute_get_request('form/' + form_id + '/webhooks')
  end

  def fetch_submission(sid)
    execute_get_request('submission/' + sid)
  end

  def fetch_report(report_id)
    execute_get_request('report/' + report_id)
  end

  def fetch_folder(folder_id)
    execute_get_request('folder/' + folder_id)
  end

  def create_form_webhook(form_id, webhook_url)
    execute_post_request('form/' + form_id + '/webhooks', { 'webhook_url' => webhook_url })
  end

  def create_form_submissions(form_id, submission)
    execute_post_request('form/' + form_id + '/submissions', submission)
  end

  private

  def execute_http_request(endpoint, parameters = nil, type = 'GET')
    url = [@base_url, @api_version, endpoint].join('/').concat('?apiKey=' + @api_key)
    puts url
    url = URI.parse(url)

    case type
    when 'GET'
      response = Net::HTTP.get_response(url)
    when 'POST'
      response = Net::HTTP.post_form(url, parameters)
    end

    return JSON.parse(response.body)['content'] if response.is_a? Net::HTTPSuccess

    puts JSON.parse(response.body)['message']
    nil
  end

  def execute_get_request(endpoint, parameters = [])
    execute_http_request(endpoint, parameters, 'GET')
  end

  def execute_post_request(endpoint, parameters = [])
    execute_http_request(endpoint, parameters, 'POST')
  end
end
