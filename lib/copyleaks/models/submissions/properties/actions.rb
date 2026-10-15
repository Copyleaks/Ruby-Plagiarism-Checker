module Copyleaks
  class SubmissionActions
    # Start the scan immediately.
    SCAN = 0
    # Only report how many credits the scan would use.
    CHECKCREDITS = 1
    # Only index the file in the Copyleaks internal database; uses no credits.
    INDEXONLY = 2
  end
end
