//
//  RegexHelpers.swift
//  iRegex
//
//  Created by Kitten Yang on 4/16/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation

//*******************************************
//********* 在第六步中调用：生成正则表达式 *******
//*******************************************


//这个扩展是用来生成一个正则表达式的，因为正则表达式需要根据过滤条件(是否区分大小写、是匹配整个单词还是包含这个单词即可)不同而不同，所以我们需要传入过滤条件SearchOptions
extension NSRegularExpression {
    convenience init?(options:SearchOptions){
        let searchString = options.searchString
        let isCaseSensitive = options.matchCase
        let isWholeWords = options.wholeWords
        
        //区分大小写设置NSRegularExpressionOptions为allZeros(默认，默认区分大小写)；不区分大小写设置NSRegularExpressionOptions为CaseInsensitive
        let regexOption: NSRegularExpressionOptions = (isCaseSensitive) ? .allZeros : .CaseInsensitive
        
        //匹配整个字符，正则表达为“\bXXX\b”,但在代码中需要转义第一个斜杠，所以应该是"\\bXXX\\b"；包含这个单词即可，正则表达式就直接是"XXX"
        let pattern = (isWholeWords) ? "\\b\(searchString)\\b" : searchString
        
        //调用原生的初始化方法，传入上面的正则表达式以及option
        self.init(pattern: pattern, options: regexOption, error: nil)
    }
    
    //xx/xx/xx or xx.xx.xx or xx-xx-xx
    class func regularExpressionForDates() -> NSRegularExpression? {
        let pattern = "(\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{1,2})|(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s*(\\d{1,2}(st|nd|rd|th)?+)?[,]\\s*\\d{4}"
        return NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    }

    class func regularExpressionForTimes() -> NSRegularExpression? {
        let pattern = "\\d{1,2}\\s*(pm|am)"
        return NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    }

    class func regularExpressionForLocations() -> NSRegularExpression? {
        let pattern = "[a-zA-Z]+[,]\\s*([A-Z]{2})"
        return NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    }

    
}



