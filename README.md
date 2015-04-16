# HowRegexWorks-Swift
用Swift学习Regex是如何工作（笔记+源码）

###--文章中用到的符号解释：
A --- 表示功能1：**实现替换字符或者高亮字符**

B --- 表示功能2：**实现数据验证，验证比如输入的是否是电话号码或者邮件**

C --- 表示功能3：

1/6 --- **6步中的第一步**

2/6 --- **6步中的第二步**
...

---



###--A功能：**实现替换字符或者高亮字符**

####**第A:1/6步：点击search弹出设置过滤条件的页面**

####**第A:2/6步：viewWillAppear**
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

####**第A:3/6步：点击Search**

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

####**第A:4/6步：点击Search**
