let greeting = "Hello Tom, Dick, Harry!"
listMatches("(Tom|Dick|Harry)", inString: greeting)
replaceMatches("(Tom|Dick|Harry)", inString: greeting, withString: "James")
