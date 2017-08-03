//
//  KNTableAertView.h
//  AlertViewList
//
//  Created by 刘凡 on 2017/7/27.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KNTableAlertViewBlock)(NSInteger index);

@interface KNTableAlertView : UIView


/**
 表格式弹出由下向上

 @param title 主标题,不能点击的
 @param destructiveTitle 破坏性标题,表示隐藏。这个列表
 @param otherTitles 展示内容标题
 @param block 回调函数。index顺序依次从上往下
 */
+(void)ShowWithTitle:(NSString *)title DestructiveTitle:(NSString *)destructiveTitle OtherTitles:(NSArray *)otherTitles block:(KNTableAlertViewBlock)block;

@end
