let cinema = "Are we going to the cinema at 3 pm or 5 pm?"
listMatches("\\d (am|pm)", inString: cinema)
listGroups("(\\d (am|pm))", inString: cinema)
