require 'dotenv/load'
require File.expand_path('helper/google_drive_handler.rb', __dir__)
require 'furik/cli'


def fetch_github_activity_today
  system('furik activity')
end

def fetch_github_activity_yesteday
  system("furik activity\s" \
         "--from #{(Date.today - 1).to_s} --to #{(Date.today - 1).to_s}")
end

def generate_report_for_today
  fetch_github_activity_today
end

def generate_report_for_yesterday
  fetch_github_activity_yesteday
end

# main
generate_report_for_today
