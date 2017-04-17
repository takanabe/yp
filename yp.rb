require 'date'
require 'dotenv/load'
require File.expand_path('helper/google_drive_handler.rb', __dir__)
require File.expand_path('helper/wuderlist_handler.rb', __dir__)
require 'furik/cli'

$session = GoogleDrive::Session.from_config(".config.json")
$spreadsheet_id = ENV["GOOGLE_SPREAD_SHEET_ID"]

def fetch_github_activity_today
  system('furik activity')
end

def fetch_github_activity_yesteday
  system("furik activity\s" \
         "--from #{(Date.today - 1).to_s} --to #{(Date.today - 1).to_s}")
end

def generate_report_for_today
  fetch_github_activity_today
  fetch_wunderlist_activoty_for_today
end

def generate_report_for_yesterday
  fetch_github_activity_yesteday
end

def fetch_wunderlist_activoty_for_today
  wl = Wunderlist.new()
  wl.fetch_all_lists_from_folder("Cookpad")
  puts "# Wunderlist activity"
  wl.fetch_completed_tasks_for_list.each do |completed_task|
    puts "- #{completed_task}"
  end
end

# main
generate_report_for_today
