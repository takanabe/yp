require 'dotenv/load'
require File.expand_path('helper/google_drive_handler.rb', __dir__)
require 'furik/cli'

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config(".config.json")

# shared test spread sheet id
#spreadsheet_id = "1S63IDvYxYIVjWg-UodB3ek7oCMGMLLKIm0UIJ_4R3Ho"
#puts find_password_from_google_spreadsheet(session, spreadsheet_id, "test_key")
#puts find_password_from_google_spreadsheet(session, spreadsheet_id, "test_key2")

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
