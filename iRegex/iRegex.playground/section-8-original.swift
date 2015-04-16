let htmlString = "<p>This is an example <strong>html</strong> string.</p>"

listMatches("<([a-z][a-z0-9]*)\\b[^>]*>(.*?)", inString: htmlString)
