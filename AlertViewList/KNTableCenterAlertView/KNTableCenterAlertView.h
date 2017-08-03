//
//  KNTableCenterAlertView.h
//  AlertViewList
//
//  Created by 刘凡 on 2017/7/31.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void(^KNTableCenterAlertViewBlock)(NSInteger index);

@interface KNTableCenterAlertView : UIView



//设置titleColor
@property(nonatomic, strong)UIColor *TitleColor;

/**
 初始化菜单,选择你需要的格式，可以不传标题,可以不传图片。必须传列表数组，至少一个以上！ 否则什么都不显示

 @param title 标题
 @param images 图片数组
 @param listTitles 内容数组
 @param block 返回的下标
 */
+(void)ShowWithTitle:(NSString *)title
          Images:(NSArray <UIImage *> *)images
          ListTitles:(NSArray <NSString *>*)listTitles
           block:(KNTableCenterAlertViewBlock)block;
@end
