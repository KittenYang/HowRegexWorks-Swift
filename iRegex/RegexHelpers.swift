//
//  RegexHelpers.swift
//  iRegex
//
//  Created by Kitten Yang on 4/16/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    convenience init?(options:SearchOptions){
        let searchString = options.searchString
        let isCaseSensitive = options.matchCase
        let isWholeWords = options.wholeWords
        
        let regexOption: NSRegularExpressionOptions = (isCaseSensitive) ? .allZeros : .CaseInsensitive
        
        let pattern = (isWholeWords) ? "\\b\(searchString)\\b" : searchString
        
        self.init(pattern: pattern, options: regexOption, error: nil)
    }
}