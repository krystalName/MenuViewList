//
//  KNMeunAlertView.h
//  AlertViewList
//
//  Created by 刘凡 on 2017/8/1.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import <UIKit/UIKit.h>


//点击事件
typedef void(^IteomsClickBlock)(NSString *str, NSInteger tag);


@interface KNMeunAlertView : UIView

@property (nonatomic, copy) IteomsClickBlock itemsClickBlock;



+(KNMeunAlertView *)createMenuWithFrame:(CGRect )frame titleArray:
(NSArray *)titleArray ImageArray:(NSArray *)ImageArray itemsClick:(void(^)(NSString *str,NSInteger tag))itemsClickBlock bakeViewHideBlock:
(void(^)(void))bakeHideBlock;







@end
