//
//  SearchOptionsViewController.swift
//  iRegex
//
//  Created by James Frost on 12/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

struct SearchOptions {
    let searchString: String
    var replacementString: String?
    let matchCase: Bool
    let wholeWords: Bool
}

class SearchOptionsViewController: UITableViewController {
    
    var searchOptions: SearchOptions?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var replacementTextField: UITextField!
    @IBOutlet weak var replaceTextSwitch: UISwitch!
    @IBOutlet weak var matchCaseSwitch: UISwitch!
    @IBOutlet weak var wholeWordsSwitch: UISwitch!
    
    struct Storyboard {
        struct Identifiers {
            static let UnwindSegueIdentifier = "UnwindSegue"
        }
    }
    
    //*******************************************
    //******** 第二步：viewWillAppear ************
    //*******************************************
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //如果已经搜索过，那么默认会显示这些条件
        if let options = searchOptions {
            searchTextField.text = options.searchString
            replacementTextField.text = options.replacementString
            replaceTextSwitch.on = (options.replacementString != nil)
            matchCaseSwitch.on = options.matchCase
            wholeWordsSwitch.on = options.wholeWords
        }
        
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        searchOptions = nil
        
        performSegueWithIdentifier(Storyboard.Identifiers.UnwindSegueIdentifier, sender: self)
    }
    
    //*******************************************
    //***********  第三步：点击Search  ************
    //*******************************************

    @IBAction func searchTapped(sender: AnyObject) {

        //这时结构体的默认初始化方法，很方便设置其内部的全部变量
        searchOptions = SearchOptions(searchString: searchTextField.text,
                                      replacementString: (replaceTextSwitch.on) ? replacementTextField.text : nil,
                                      matchCase: matchCaseSwitch.on,
                                      wholeWords: wholeWordsSwitch.on )

        //启动返回主页面的Segue
        performSegueWithIdentifier(Storyboard.Identifiers.UnwindSegueIdentifier, sender: self)
    }
    
    @IBAction func replaceTextSwitchToggled(sender: AnyObject) {
        replacementTextField.enabled = replaceTextSwitch.on
    }
}
