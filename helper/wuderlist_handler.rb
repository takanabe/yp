require 'open-uri'
require 'json'
class Wunderlist
  API_URL = 'https://a.wunderlist.com/api/v1/'

  attr_reader :ids

  def fetch_all_lists_from_folder(foldername)
    request_url = create_url('folders')
    res = api_request(request_url)
    res.collect do  |list|
      @ids = list["list_ids"] if list["title"] == foldername
    end
  end

  def fetch_completed_tasks_for_list
    completed_tasks = []
    @ids.each do |id|
      request_url = create_url_with_params('tasks',{list_id: id, completed: true})
      tasks = api_request(request_url)
      tasks.each do |task|
        time_diff = (Date.parse(Date.today.to_s) - Date.parse(task["completed_at"])).to_i
        completed_tasks << task["title"] if time_diff == 0
      end
    end
    completed_tasks
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
