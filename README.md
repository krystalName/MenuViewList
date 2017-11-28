# MenuViewList
菜单列表


### 先看效果图

![](https://github.com/krystalName/MenuViewList/blob/MenuView/TableAlertView.gif)


## 使用方法

``` objc

    [KNTableAlertView ShowWithTitle:@"这是标题" DestructiveTitle:nil OtherTitles:@[@"1",@"2",@"3"] block:^(NSInteger index) {
       
    }];

```

# 第二种模式

### 先看效果图
![](https://github.com/krystalName/MenuViewList/blob/MenuView/TableCenterAlertView.gif)

## 使用方式有两种。
+ 使用没有设置默认选中的模式

```objc
    //定义一个图片数组
    NSArray <UIImage *> * images =@[[UIImage imageNamed:@"right_menu_addFri"],[UIImage imageNamed:@"right_menu_facetoface"],[UIImage imageNamed:@"right_menu_multichat"],[UIImage imageNamed:@"right_menu_payMoney"]
                                    ];

    [KNTableCenterAlertView ShowWithTitle:@"这是标题" Images:images ListTitles:@[@"ansdnj",@"asmk",@"asnjdakjs",@"asdasda",@"assad"] block:^(NSInteger index) {
        
    }];
```


+ 使用设置默认选中的模式。  为了避免冲突。所以下标0 就代表 不默认。 下标1开始以此内推 
``` objc
    //定义一个图片数组
    NSArray <UIImage *> * images =@[[UIImage imageNamed:@"right_menu_addFri"],[UIImage imageNamed:@"right_menu_facetoface"],[UIImage imageNamed:@"right_menu_multichat"],[UIImage imageNamed:@"right_menu_payMoney"]
                                    ];
  [KNTableCenterAlertView ShowWIthTitle:@"这是标题" Images:images ListTitles:@[@"ansdnj",@"asmk",@"asnjdakjs",@"asdasda",@"assad"] SelectedIndex:1 block:^(NSInteger index) {
        
    }];
```

# 第三种模式  效果图如下
![](https://github.com/krystalName/MenuViewList/blob/MenuView/KNMenuView.gif)

+ 使用方法和上面两种稍微不用。 因为要设置所展示的位置

``` objc
  
    //定义一个图片数组
    NSArray <UIImage *> * images =@[[UIImage imageNamed:@"right_menu_addFri"],[UIImage imageNamed:@"right_menu_facetoface"],[UIImage imageNamed:@"right_menu_multichat"],[UIImage imageNamed:@"right_menu_payMoney"]
                                    ];

    
    [KNTableCenterAlertView ShowWIthTitle:@"这是标题" Images:images ListTitles:@[@"ansdnj",@"asmk",@"asnjdakjs",@"asdasda",@"assad"] SelectedIndex:1 block:^(NSInteger index) {
        
    }];

//还要在适当的地方调用   设置一个CGPointMake
   [KNMenuAlertView showMenuAtPoint:CGPointMake(30, 50)];
```
