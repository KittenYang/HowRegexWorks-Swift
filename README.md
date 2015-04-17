# HowRegexWorks-Swift
用Swift学习Regex是如何工作（笔记+源码）

###--文章中用到的符号解释：
A --- 表示功能1：**实现替换字符或者高亮字符**

B --- 表示功能2：**实现数据验证，验证比如输入的是否是电话号码或者邮件**

C --- 表示功能3：

1/5 --- **5步中的第一步**

2/5 --- **5步中的第二步**

...

---



###--A功能：**实现替换字符或者高亮字符**

####**第A:1/5步：点击search弹出设置过滤条件的页面**

####**第A:2/5步：viewWillAppear**
如果已经搜索过，那么默认会显示这些条件
```
        if let options = searchOptions {
            searchTextField.text = options.searchString
            replacementTextField.text = options.replacementString
            replaceTextSwitch.on = (options.replacementString != nil)
            matchCaseSwitch.on = options.matchCase
            wholeWordsSwitch.on = options.wholeWords
        }
```

####**第A:3/5步：点击Search返回首界面**

因为搜索的过滤条件是一个结构体：
```
struct SearchOptions {
    let searchString: String
    var replacementString: String?
    let matchCase: Bool
    let wholeWords: Bool
}
```

所以可以很方便设置其内部的全部变量
```
        searchOptions = SearchOptions(searchString: searchTextField.text,
                                      replacementString: (replaceTextSwitch.on) ? replacementTextField.text : nil,
                                      matchCase: matchCaseSwitch.on,
                                      wholeWords: wholeWordsSwitch.on )
```

启动返回主页面的Segue
```
        performSegueWithIdentifier(Storyboard.Identifiers.UnwindSegueIdentifier, sender: self)
```

####**第A:4/5步：从过滤条件页面返回触发unwind segue**
```
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

```

####**第A:5/5步：替换或者高亮的核心代码**
```
    func performSearchWithOptions(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
        
        //如果需要替换，进入searchForText方法；如果不需要替换，进入highlightText方法
        if let replacementString = searchOptions.replacementString {
            searchForText(searchOptions.searchString, replaceWith: replacementString, inTextView: textView)
        } else {
            highlightText(searchOptions.searchString, inTextView: textView)
        }
    }

```

####如果是替换字符
```
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
```

####如果是高亮字符
```
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

```


