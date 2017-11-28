//
//  KNMeunAlertView.h
//  AlertViewList
//
//  Created by 刘凡 on 2017/8/1.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import <UIKit/UIKit.h>


//点击事件
typedef void(^IteomsClickBlock)(NSString *str,NSInteger tag);


@interface KNMenuAlertView : UIView

@property (nonatomic, copy) IteomsClickBlock itemsClickBlock;

/**
 初始化菜单,选择你需要的格式，可以不传标题,可以不传图片。必须传列表数组，至少一个以上！ 否则什么都不显示
 
 @param images 图片数组
 @param listTitles 内容数组
 @param block 返回的下标
 */
+(KNMenuAlertView * )createViewWiththImages:(NSArray <UIImage *> *)images
          ListTitles:(NSArray <NSString *>*)listTitles
               block:(IteomsClickBlock)block;

//展示菜单, 定点展示
+(void)showMenuAtPoint:(CGPoint)point;






@end
