#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Format Markdown
# @raycast.mode silent

# Optional parameters:
# @raycast.icon markdown.png
# @raycast.packageName Prettier

# Documentation:
# @raycast.description Wrap at 72 characters and apply markdown formatting.
# @raycast.author jauer
# @raycast.authorURL https://github.com/jauer

tell application "System Events"
    keystroke "c" using {command down}
    delay 0.1
    set the clipboard to (do shell script "pbpaste | /Users/jauer/.volta/bin/prettier --parser markdown --print-width 72 --prose-wrap always")
    delay 0.1
    keystroke "v" using {command down}
end
