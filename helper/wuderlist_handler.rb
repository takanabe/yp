require 'open-uri'
require 'json'
class Wunderlist
  API_URL = 'https://a.wunderlist.com/api/v1/'

  attr_reader :ids, :completed_tasks

  def initialize
    @list_ids = []
    @completed_tasks = {}
  end

  def fetch_all_lists_from_folder(foldername)
    request_url = create_url('folders')
    res = api_request(request_url)
    res.collect do  |folder|
      @list_ids = folder["list_ids"] if folder["title"] == foldername
    end
  end

  def fetch_list_name(list_id)
    request_url = create_url("lists/#{list_id}")
    list = api_request(request_url)
    list["title"]
  end

  def fetch_completed_tasks_for_list
    @list_ids.each do |list_id|
      completed_tasks = []
      request_url = create_url_with_params('tasks',{list_id: list_id, completed: true})
      tasks = api_request(request_url)
      tasks.each do |task|
        time_diff = (Date.parse(Date.today.to_s) - Date.parse(task["completed_at"])).to_i
        if time_diff == 0
          completed_tasks << task["title"]
        end
      end
      unless completed_tasks.empty?
        @completed_tasks[fetch_list_name(list_id)] = completed_tasks
      end
    end
  end

  def fetch_completed_tasks_for_list_yesterday
    @list_ids.each do |list_id|
      completed_tasks = []
      request_url = create_url_with_params('tasks',{list_id: list_id, completed: true})
      tasks = api_request(request_url)
      tasks.each do |task|
        time_diff = (Date.parse(Date.today.to_s) - Date.parse(task["completed_at"])).to_i
        if time_diff == 1
          completed_tasks << task["title"]
        end
      end
      unless completed_tasks.empty?
        @completed_tasks[fetch_list_name(list_id)] = completed_tasks
      end
    end
  end

  def headers
    {
      "X-Access-Token" => find_credential_value_from_google_spreadsheet($session, $spreadsheet_id, ENV["WUNDERLIST_ACCESS_TOKEN"]),
      "X-Client-ID" => find_credential_value_from_google_spreadsheet($session, $spreadsheet_id, ENV["WUNDERLIST_CLIENT_ID"]),
    }
  end

  def api_request(request_url)
    res = open(request_url, headers)
    code, message = res.status

    if code == '200'
      return JSON.parse(res.read)
    end
  end

  def create_url(action)
    API_URL + action
  end

  def create_url_with_params(action, params)
    API_URL + action + '?' + URI.encode_www_form(params)
  end
end
