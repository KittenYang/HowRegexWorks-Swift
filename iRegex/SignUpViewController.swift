//
//  SignUpViewController.swift
//  iRegex
//
//  Created by James Frost on 13/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var middleInitialField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    
    var textFields: [UITextField]!
    var regexes: [NSRegularExpression?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [firstNameField,middleInitialField,lastNameField,dateOfBirthField]
        let patterns = ["^[a-z]{1,10}$",      // First name
                        "^[a-z]$",            // Middle Initial
                        "^[a-z']{2,10}$",     // Last Name
                        "^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$" ]  // Date of Birth
        
        //用swift的map函数 创建pattern的一个映射，每一个正则表达式对应一个NSRegularExpression对象，一一对应。
        regexes = patterns.map{NSRegularExpression(pattern:$0, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)}
        
    }

    func validateTextField(textField: UITextField) {
        
        //find函数：在给定序列中返回指定目标的索引，没有返回nil
        let index = find(textFields, textField)
        if let regex = regexes[index!] {
            //stringByTrimmingCharactersInSet 方法是去掉后面所给的字符集，所给的NSCharacterSet.whitespaceAndNewlineCharacterSet() 表示去掉两端的空格
            let text = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            let range =  NSMakeRange(0, count(text))

            //获得匹配到的字符所在的位置
            let matchRange = regex.rangeOfFirstMatchInString(text, options: NSMatchingOptions.ReportProgress, range: range)

            //如果存在这个matchRange，颜色为trueColor()；如果不存在这个matchRange，颜色falseColor()
            let valid = matchRange.location != NSNotFound
            textField.textColor = (valid) ? UIColor.trueColor() : UIColor.falseColor()
        }
        
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        for textField in textFields {
            validateTextField(textField)
            textField.resignFirstResponder()
        }
    }
}

//新技能get，以后不用很傻地设置TextField.delegate = self了，直接写一个扩展就全部搞定了
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textColor = UIColor.blackColor()
        doneButton.enabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        validateTextField(textField)
        doneButton.enabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        validateTextField(textField)
        
        makeNextTextFieldFirstResponder(textField)
        
        return true
    }
    
    func makeNextTextFieldFirstResponder(textField: UITextField) {
        textField.resignFirstResponder()

        if var index = find(textFields, textField) {
            index++
            if index < textFields.count {
                textFields[index].becomeFirstResponder()
            }
        }
    }
}

extension UIColor {
    class func trueColor() -> UIColor {
        return UIColor(red: 0.1882, green:0.6784, blue:0.3882, alpha:1.0)
    }
    
    class func falseColor() -> UIColor {
        return UIColor(red:0.7451, green:0.2275, blue:0.1922, alpha:1.0)
    }
}

