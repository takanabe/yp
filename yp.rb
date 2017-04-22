require 'date'
require 'dotenv/load'
require File.expand_path('helper/google_drive_handler.rb', __dir__)
require File.expand_path('helper/wuderlist_handler.rb', __dir__)
require 'furik/cli'

$session = GoogleDrive::Session.from_config(".config.json")
$spreadsheet_id = ENV["GOOGLE_SPREAD_SHEET_ID"]


def fetch_github_activity_today
  system('furik activity -l')
end

def fetch_github_activity_yesteday
  system("furik activity -l \s" \
         "--from #{(Date.today - 1).to_s} --to #{(Date.today - 1).to_s}")
end

def generate_report_for_today
  fetch_wunderlist_activoty_for_today
  fetch_github_activity_today
end

def generate_report_for_yesterday
  fetch_wunderlist_activoty_for_yesterday
  fetch_github_activity_yesteday
end

def fetch_wunderlist_activoty_for_today
  wl = Wunderlist.new()
  wl.fetch_all_lists_from_folder(EVN["TARGET_FOLDER"])
  puts "# Wunderlist activities"
  wl.fetch_completed_tasks_for_list
  wl.completed_tasks.each do |list,tasks|
    puts "## #{list}"
    tasks.each do |task|
      puts "- #{task}"
    end
    puts ""
  end
end

def fetch_wunderlist_activoty_for_yesterday
  wl = Wunderlist.new()
  wl.fetch_all_lists_from_folder(EVN["TARGET_FOLDER"])
  puts "# Wunderlist activities"
  wl.fetch_completed_tasks_for_list_yesterday
  wl.completed_tasks.each do |list,tasks|
    puts "## #{list}"
    tasks.each do |task|
      puts "- #{task}"
    end
    puts ""
  end
end

# main
generate_report_for_today
# generate_report_for_yesterday
