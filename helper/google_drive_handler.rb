require "google_drive"

def find_credential_value_from_google_spreadsheet(session, spreadsheet_id, target_key)
  ws = session.spreadsheet_by_key(spreadsheet_id).worksheets.first
  (1..ws.num_rows).each do |row|
    key = ws[row, 1].strip
    password = ws[row, 2].strip

    if target_key == key
      return password
    end
  end
end

## shared test spread sheet id
#spreadsheet_id = "1S63IDvYxYIVjWg-UodB3ek7oCMGMLLKIm0UIJ_4R3Ho"
#puts find_password_from_google_spreadsheet(session, spreadsheet_id, "test_key")
#puts find_password_from_google_spreadsheet(session, spreadsheet_id, "test_key2")
