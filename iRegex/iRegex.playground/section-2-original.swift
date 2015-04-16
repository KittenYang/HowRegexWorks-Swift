import UIKit

func highlightMatches(pattern: String, inString string: String) -> NSAttributedString {
    let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
    let range = NSMakeRange(0, countElements(string))
    let matches = regex?.matchesInString(string, options: .allZeros, range: range) as [NSTextCheckingResult]

    let attributedText = NSMutableAttributedString(string: string)

    for match in matches {
        attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: match.range)
    }

    return attributedText.copy() as NSAttributedString
}

func listMatches(pattern: String, inString string: String) -> [String] {
    let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
    let range = NSMakeRange(0, countElements(string))
    let matches = regex?.matchesInString(string, options: .allZeros, range: range) as [NSTextCheckingResult]

    return matches.map {
        let range = $0.range
        return (string as NSString).substringWithRange(range)
    }
}

func listGroups(pattern: String, inString string: String) -> [String] {
    let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
    let range = NSMakeRange(0, countElements(string))
    let matches = regex?.matchesInString(string, options: .allZeros, range: range) as [NSTextCheckingResult]

    var groupMatches = [String]()
    for match in matches {
        let rangeCount = match.numberOfRanges

        for group in 0..<rangeCount {
            groupMatches.append((string as NSString).substringWithRange(match.rangeAtIndex(group)))
        }
    }

    return groupMatches
}

func containsMatch(pattern: String, inString string: String) -> Bool {
    let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
    let range = NSMakeRange(0, countElements(string))
    return regex?.firstMatchInString(string, options: .allZeros, range: range) != nil
}

func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
    let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
    let range = NSMakeRange(0, countElements(string))

    return regex?.stringByReplacingMatchesInString(string, options: .allZeros, range: range, withTemplate: replacementString)
}
