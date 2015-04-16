let numberExample1 = "101 1001 10001"
let numberExample2 = "HeLLo HellLLLllo"
highlightMatches("10{1,2}1", inString: numberExample1)
highlightMatches("He[Ll]{2,}", inString: numberExample2)
