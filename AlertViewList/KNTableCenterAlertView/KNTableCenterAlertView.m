//
//  KNTableCenterAlertView.m
//  AlertViewList
//
//  Created by 刘凡 on 2017/7/31.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "KNTableCenterAlertView.h"


//标题文字大小
#define TitleFont [UIFont systemFontOfSize:14]
//列表字体大小
#define ListButtonFont  [UIFont systemFontOfSize:14]


//颜色
#define ViewBackgroundColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]
#define TitleColor [UIColor colorWithRed:249/255.0 green:37/255.0 blue:114/255.0 alpha:1]
#define ListButtonBackgroundColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:1]
#define ListButtonClolor [UIColor blackColor]
#define ListButtonSelectdColor  [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]
#define ListHighlightedColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]
#define ContentViewBackgroundColor  [UIColor clearColor]

//系统高度
#define  WindowWidth [UIScreen mainScreen].bounds.size.width
#define  WindowHeight [UIScreen mainScreen].bounds.size.height

//高度
#define TitleHeight 44
#define ListButtonHeight 44
#define LineHeight 1.0/[UIScreen mainScreen].scale
#define ContentViewX 60
#define ContentViewWidth WindowWidth - ContentViewX * 2
#define ImageY (ListButtonHeight -25)/ 2

//圆角
#define ContentViewRadius 10

@interface KNTableCenterAlertView ()



@property(nonatomic, strong)UIView  *contentView;

/**
 图片数组
 */
@property (nonatomic, strong) NSArray <UIImage * >* images;

/**
 标题
 */
@property (nonatomic, strong) NSString *title;

/**
 标签数组
 */
@property (nonatomic, strong)NSArray <NSString *> * listTitles;

//当前选中下标
@property (nonatomic, assign)NSInteger selectedIndex;


@property (nonatomic, copy)KNTableCenterAlertViewBlock block;

@end


@implementation KNTableCenterAlertView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = ViewBackgroundColor;
        //不是点击列表的时候。点击背部View 的时候直接隐藏这个控件
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)]];
    }
    return self;
}


+(void)ShowWithTitle:(NSString *)title Images:(NSArray<UIImage *> *)images ListTitles:(NSArray<NSString *> *)listTitles block:(KNTableCenterAlertViewBlock)block{
    

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    KNTableCenterAlertView *alertView = [KNTableCenterAlertView new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    alertView.frame = window.bounds;
    alertView.title = title;
    alertView.images = images;
    alertView.listTitles = listTitles;
    alertView.block = block;
    [alertView Show];
    [window addSubview:alertView];
    
}


+(void)ShowWIthTitle:(NSString *)title Images:(NSArray<UIImage *> *)images ListTitles:(NSArray<NSString *> *)listTitles SelectedIndex:(NSInteger)selectedIndex block:(KNTableCenterAlertViewBlock)block{
    
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    KNTableCenterAlertView *alertView = [KNTableCenterAlertView new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    alertView.frame = window.bounds;
    alertView.title = title;
    alertView.images = images;
    alertView.listTitles = listTitles;
    alertView.block = block;
    alertView.selectedIndex = selectedIndex;
    [alertView Show];
    [window addSubview:alertView];
    
}



-(void)Show{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = ContentViewBackgroundColor;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = ContentViewRadius;
    self.contentView = contentView;
    
    
    CGFloat heigt = 0;

    //刚开始tag是0
    NSInteger tag = 0;
    
    if (self.title) {
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=TitleFont;
        titleLabel.textColor=TitleColor;
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.frame = CGRectMake(0, 0, ContentViewWidth, TitleHeight);
        [contentView addSubview:titleLabel];
        heigt = TitleHeight + LineHeight;
    }
    
    //这里要分情况.设置了图片。和没设置图片.
    NSInteger ImageCount = self.images.count;
    NSInteger OtherCount = self.listTitles.count;
    //如果图片数量大于。
    NSInteger count ;
    if (ImageCount > 0) {
        //如果图片数量大于内容数量.就取内容数量,否则取图片数量
        count= ImageCount > OtherCount? OtherCount : ImageCount;
     
    }else{
        count = OtherCount;
        
    }
      
        //没有设置图片
    for (int i = 0; i< count; i++) {

        UIButton * Button = [self createButtonWithTitle:self.listTitles[i] font:ListButtonFont image:ImageCount>0?self.images[i]:nil height:ListButtonHeight y:heigt + (ListButtonHeight + LineHeight) * i];
            
        
            
            if (i == count -1) {
                heigt += (ListButtonHeight + LineHeight) * i + ListButtonHeight;
                
            }
        
      
        
            Button.tag = tag;
            tag++;
        
        //判断不为nil
        if (self.selectedIndex) {
            if (self.selectedIndex == tag) {
                [Button setBackgroundColor:ListButtonSelectdColor];
            }
        }
        
        
        
            [contentView addSubview:Button];
        
        }
    
    
    
    
    //先把它放到下面去。
    CGFloat Y = ((self.bounds.size.height - heigt) / 2) - self.bounds.size.height;
    
    contentView.frame = CGRectMake( ContentViewX , Y, ContentViewWidth, heigt);
    

    
    [self addSubview:contentView];
    
    //先获取到位置
    CGRect frame = self.contentView.frame;
    CGRect newframe= frame;
    self.alpha=0.1;
    newframe.origin.y += self.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = newframe;
        self.alpha=1;
        
    } completion:nil];
    

    
}




-(UIButton*)createButtonWithTitle:(NSString*)title font:(UIFont*)font image:(UIImage *)image height:(CGFloat)height y:(CGFloat)y
{
    //整个View
    UIButton *button=[[UIButton alloc]init];
    button.backgroundColor = ListButtonBackgroundColor;
    [button setBackgroundImage:[self imageWithColor:ListHighlightedColor] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, y , ContentViewWidth, height);
    [button addTarget:self action:@selector(ButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //加上内容
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.text = title;
    titleLable.font = font;
    titleLable.textColor = ListButtonClolor;
    [button addSubview:titleLable];
    
    if (image) {
        //加上左边图标
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(15, ImageY, 25, 25);
        [button addSubview:imageView];
        titleLable.frame = CGRectMake(55, ImageY, ContentViewWidth - 60 , 25);
    }else{
        titleLable.frame = CGRectMake(15, ImageY, ContentViewWidth - 60 , 25);
    }

    


    
 
    
    return button;
}


-(void)ButClick:(UIButton *)sender{
    
    if (_block) {
        _block(sender.tag);
    }
    [self hiddenView];
}


#pragma mark - 取消
-(void)hiddenView
{
    CGRect frame= self.contentView.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame=frame;
        self.alpha=0.1;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



-(UIImage *)imageWithColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, 0, 1, 1));
    [color set];
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
