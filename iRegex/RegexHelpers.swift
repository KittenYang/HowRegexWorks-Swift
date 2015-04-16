//
//  RegexHelpers.swift
//  iRegex
//
//  Created by Kitten Yang on 4/16/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation

//这个扩展是用来生成一个正则表达式的，因为正则表达式需要根据过滤条件不同而不同，所以我们需要传入过滤条件SearchOptions
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