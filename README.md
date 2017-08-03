# MenuViewList
简易菜单列表


先看效果图

![](https://github.com/krystalName/MenuViewList/blob/MenuView/TableAlertView.gif)

### 从下往上的动画使用代码如下。不带图片显示的类似于微博。微信的选择列表

```object-c
第一个参数是标题。第二个是破坏按钮.第三个是选项列表。block中返回对应的下标
[KNTableAlertView ShowWithTitle:@"这是标题" DestructiveTitle:nil OtherTitles:@[@"1",@"2",@"3"] block:^(NSInteger index) { 
}];
```



### 第二中就是带图片。 从上面落下来的效果, 可以选择性设置图片.

第二种效果图
![](https://github.com/krystalName/MenuViewList/blob/MenuView/TableCenterAlertView.gif)

#### 使用注意事项
1.是可以选择性设置图片。文字列表必须设置。至少一个以上。否则什么都不会显示

2.设置的数量是根据images 的数量和titles的数量比较。谁最少就设置几行。多余不显示

3.可以不设置标题,标题修改颜色请自行到.m中的宏定义改.名字为TitleColor


```object-c
 定义一个图片数组
  NSArray <UIImage *> * images =@[[UIImage imageNamed:@"right_menu_addFri"],[UIImage imageNamed:@"right_menu_facetoface"],[UIImage imageNamed:@"right_menu_multichat"],[UIImage imageNamed:@"right_menu_payMoney"]
                                    ];
 [KNTableCenterAlertView ShowWithTitle:@"这是标题" Images:images ListTitles:@[@"添加好友",@"面对面快传",@"发起多人聊天",@"付款",@"扫一扫"] block:^(NSInteger index) {
}];
```
