//
//  SearchViewController.swift
//  iRegex
//
//  Created by James Frost on 11/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    struct Storyboard {
        struct Identifiers {
            static let SearchOptionsSegueIdentifier = "SearchOptionsSegue"
        }
    }
    
    var searchOptions: SearchOptions?
    
    @IBOutlet weak var textView: UITextView!

    //**********************************************
    //** 第A:4/6步：从过滤条件页面返回触发unwind segue **
    //**********************************************
    @IBAction func unwindToTextHighlightViewController(segue: UIStoryboardSegue) {
        if let searchOptionsViewController = segue.sourceViewController as? SearchOptionsViewController {
            
            //如果是点击cancel，searchOptionsViewController.searchOptions被设置成了nil，所以不会进入下面这个方法；如果是search，searchOptionsViewController.searchOptions不为空，所以会进入下面这个方法。
            //本来这里有个疑问？既然都返回了，searchOptionsViewController.searchOptions应该已经release掉了才对啊，结果在这里打了个断点发现，这个方法执行时，屏幕依然是显示searchOptionsViewController的，也就是说还没真正返回，所以下面let options = searchOptionsViewController.searchOptions就是赶紧用一个常量保存searchOptions。
            if let options = searchOptionsViewController.searchOptions {
                //进入正式查找的方法
                performSearchWithOptions(options)
            }
        }
    }
    
    //**********************************************
    //*** 第A:1/6步：点击search弹出设置过滤条件的页面 ***
    //**********************************************
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Storyboard.Identifiers.SearchOptionsSegueIdentifier) {
            if let options = self.searchOptions {
                if let navigationController = segue.destinationViewController as? UINavigationController {
                    if let searchOptionsViewController = navigationController.topViewController as? SearchOptionsViewController {
                        searchOptionsViewController.searchOptions = options
                    }
                }
            }
        }
    }
    
    
    //*******************************************
    //******** 第A:5/6步：替换或者高亮的核心代码 *****
    //*******************************************
    func performSearchWithOptions(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
        
        //如果需要替换，进入searchForText方法；如果不需要替换，进入highlightText方法
        if let replacementString = searchOptions.replacementString {
            searchForText(searchOptions.searchString, replaceWith: replacementString, inTextView: textView)
        } else {
            highlightText(searchOptions.searchString, inTextView: textView)
        }
    }
    
    //**********************************************
    //********* 第A:6(1)/6步：替换字符的核心代码 *******
    //**********************************************
    func searchForText(searchText: String, replaceWith replacementText: String, inTextView textView: UITextView) {
        let beforeText = textView.text
        let range = NSMakeRange(0, count(beforeText))
        
        //*********************************************************
        //********* 在第六步中：调用"RegexHelpers"生成正则表达式 *******
        //*********************************************************        
        if let regex = NSRegularExpression(options: self.searchOptions!){

            //regex就是正则表达式，范围是整个文本，在整个文本里面用"正则表达式"去匹配，返回一个替换之后的文本，再把替换之后的文本重新赋值给textView
            let afterText = regex.stringByReplacingMatchesInString(beforeText, options: NSMatchingOptions.allZeros, range: range, withTemplate: replacementText)
            textView.text  = afterText
        }
    }
    
    //**********************************************
    //********* 第A:6(2)/6步：高亮字符的核心代码 *******
    //**********************************************
    func highlightText(searchText: String, inTextView textView: UITextView) {

        //可变拷贝一份textView的attributedText
        let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        
        //范围还是全文，并把原来上一次的高亮都移除，计算NSMutableAttributedString的长度可以用attributedText.length
        let attributedTextRange = NSMakeRange(0, attributedText.length)
        attributedText.removeAttribute(NSBackgroundColorAttributeName, range: attributedTextRange)

        //*********************************************************
        //********* 在第六步中：调用"RegexHelpers"生成正则表达式 *******
        //*********************************************************
        if let regex = NSRegularExpression(options: self.searchOptions!) {
            //计算textView.text的长度要用 count(textView.text)
            let range = NSMakeRange(0, count(textView.text))

            //这个方法返回一个数组，数组里面是匹配得到的结果。每个结果是AnyObject类型的。所以我们需要转成NSTextCheckingResult这个类型。这个类型中有一个变量可以获取当前结果在全文中的range。
            let matches = regex.matchesInString(textView.text, options: .allZeros, range: range)
            
            //遍历每一个匹配项（把它们转换成NSTextCheckingResult对象），并为每一项添加黄色背景。
            for match in matches as! [NSTextCheckingResult] {
                let matchRange = match.range //这个range是全文中的range
                //每一个match都设置背景色
                attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: matchRange)
            }
        }
        
        textView.attributedText = attributedText.copy() as! NSAttributedString
    }
    
    func rangeForAllTextInTextView() -> NSRange {
        return NSMakeRange(0, count(textView.text))
    }

    //给日期、时间、位置加上蓝色字体和下划线
    @IBAction func underlineInterestingData(sender: AnyObject) {
        underlineAllDates()
        underlineAllTimes()
        underlineAllLocations()
    }

    func underlineAllDates() {
        if let regex = NSRegularExpression.regularExpressionForDates(){
            let matches = matchesForRegularExpression(regex, inTextView: textView)
            highlightMatches(matches)
        }
    }
    
    func underlineAllTimes() {
        if let regex = NSRegularExpression.regularExpressionForTimes(){
            let matches = matchesForRegularExpression(regex, inTextView: textView)
            highlightMatches(matches)
        }
    }
    
    func underlineAllLocations() {
        if let regex = NSRegularExpression.regularExpressionForLocations(){
            let matches = matchesForRegularExpression(regex, inTextView: textView)
            highlightMatches(matches)
        }
    }
    
    func matchesForRegularExpression(regex: NSRegularExpression, inTextView textView: UITextView) -> [NSTextCheckingResult] {
        let string = textView.text
        let range = rangeForAllTextInTextView()
        
        return regex.matchesInString(string, options: .allZeros, range: range) as! [NSTextCheckingResult]
    }
    
    func highlightMatches(matches: [NSTextCheckingResult]) {
        let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let attributedTextRange = NSMakeRange(0, attributedText.length)
        attributedText.removeAttribute(NSBackgroundColorAttributeName, range: attributedTextRange)
        
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: matchRange)
            attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: matchRange)
        }
        
        textView.attributedText = attributedText.copy() as! NSAttributedString
    }
    
    func addTapGes(attriText:NSMutableAttributedString!){
        
    }
}
