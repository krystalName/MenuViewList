//
//  KNTableAertView.m
//  AlertViewList
//
//  Created by 刘凡 on 2017/7/27.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "KNTableAlertView.h"

//标题文字大小
#define TitleFont [UIFont systemFontOfSize:14]
//取消字体的字体大小
#define CancelButtonFont [UIFont systemFontOfSize:14]
//破坏性质的字体大小
#define DestructiveButtonFont [UIFont systemFontOfSize:14]
//列表字体大小
#define ListButtonFont  [UIFont systemFontOfSize:14]

//颜色
#define CancelButtonColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:1]

#define ViewBackgroundColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]

#define TitleColor [UIColor colorWithRed:249/255.0 green:37/255.0 blue:114/255.0 alpha:1]

#define ListButtonClolor [UIColor blackColor]
#define ListHighlightedColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:0.5]

//高度
#define CancelButtonHeight 50
#define TitleHeight 50
#define ListButtonHeight 50
#define LineHeight 1.0/[UIScreen mainScreen].scale

//距离
#define TitleLeftMargin 20
#define TitTopMargin 20
#define CancelTopMargin 5

//系统高度
#define  WindowWidth [UIScreen mainScreen].bounds.size.width
#define  WindowHeight [UIScreen mainScreen].bounds.size.height


@interface KNTableAlertView ()

@property(nonatomic, weak)UIView *contentView;

@property(nonatomic, strong)NSString *Title;
@property(nonatomic, strong)NSString *destructiveTitle;
@property(nonatomic, strong)NSArray *otherTitles;

@property(nonatomic, copy)KNTableAlertViewBlock block;

@end

@implementation KNTableAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ViewBackgroundColor;
        
        //不是点击列表的时候。点击背部View 的时候直接隐藏这个控件
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)]];
    }
    return self;
}

-(void)handleGesture:(UITapGestureRecognizer*)tap
{
    //如果当前的高度减去内容的高度 大于 view这个视图上的位置(表示点击到了上面的背景View)
    if ([tap locationInView:tap.view].y < self.frame.size.height -self.contentView.frame.size.height) {
        [self hiddenView];
    }
}


+(void)ShowWithTitle:(NSString *)title DestructiveTitle:(NSString *)destructiveTitle OtherTitles:(NSArray *)otherTitles block:(KNTableAlertViewBlock)block{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    KNTableAlertView *alertView = [KNTableAlertView new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    alertView.frame = window.bounds;
    alertView.Title = title;
    alertView.destructiveTitle = destructiveTitle;
    alertView.otherTitles = otherTitles;
    alertView.block = block;
    [alertView Show];
    [window addSubview:alertView];
    
}

//展示
-(void)Show{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:0.5];
    self.contentView = contentView;
    
    
    CGFloat y = 0;
    //刚开始tag是0
    NSInteger tag = 0;
    
    //先判断这个值是否给参数了..如果不为空就创建一个标题
    if (self.Title) {
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=TitleFont;
        
        titleLabel.textColor=TitleColor;
        
        
        titleLabel.numberOfLines=0;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text=self.Title;
        titleLabel.tag=tag;
        CGSize size= [self.Title boundingRectWithSize:CGSizeMake(WindowWidth-2*TitleLeftMargin, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:titleLabel.font}
                                              context:nil]
        .size;
        
        titleLabel.frame=CGRectMake(TitleLeftMargin, TitTopMargin,WindowWidth-2* TitleLeftMargin ,size.height );
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=CancelButtonColor;
        view.frame=CGRectMake(0, 0, WindowWidth, size.height+2*TitTopMargin);
        [contentView addSubview:view];
        [contentView addSubview:titleLabel];
        y=size.height+2*TitTopMargin + LineHeight;
    }
    
    
    //循环创建列表选择
    for (int i = 0; i < self.otherTitles.count; i++) {
        UIButton *button = [self createButtonWithTitle:self.otherTitles[i]  font:ListButtonFont height:ListButtonHeight y:y+(ListButtonHeight + LineHeight) * i];
        
        [contentView addSubview:button];
        if (i == self.otherTitles.count -1) {
            y += (ListButtonHeight + LineHeight) * i + ListButtonHeight;
            
        }
        button.tag = tag;
        tag ++;
    }
    
    //如果破坏字段存在
    if (self.destructiveTitle) {
        UIButton  *button = [self createButtonWithTitle:self.destructiveTitle font:DestructiveButtonFont height:TitleHeight y:y+LineHeight];
        button.tag = tag;
        [contentView addSubview:button];
        y+= (TitleHeight + CancelTopMargin);
        tag++;
    }else{
        y+= CancelTopMargin;
    }
    
    //添加一个底部的取消按钮
    
    UIButton *cancel = [self createButtonWithTitle:@"取消" font:CancelButtonFont height:CancelButtonHeight y:y];
    cancel.tag = tag;
    [contentView addSubview:cancel];
    
    
    CGFloat maxY= CGRectGetMaxY(contentView.subviews.lastObject.frame);
    contentView.frame=CGRectMake(0, self.frame.size.height-maxY, WindowWidth, maxY) ;
    [self addSubview:contentView];
    
    
    CGRect frame= self.contentView.frame;
    
    CGRect newframe= frame;
    self.alpha=0.1;
    newframe.origin.y=self.frame.size.height;
    
    contentView.frame=newframe;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame=frame;
        self.alpha=1;
        
    }completion:^(BOOL finished) {
        
    }];

}



-(void)ButClick:(UIButton *)sender{
    
    if (_block) {
        _block(sender.tag);
    }
    [self hiddenView];
}

-(UIButton*)createButtonWithTitle:(NSString*)title font:(UIFont*)font height:(CGFloat)height y:(CGFloat)y
{
    
    UIButton *button=[[UIButton alloc]init];
    button.backgroundColor = CancelButtonColor;
    [button setBackgroundImage:[self imageWithColor:ListHighlightedColor] forState:UIControlStateHighlighted];
    button.titleLabel.font=font;
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:ListButtonClolor forState:UIControlStateNormal];
    button.frame=CGRectMake(0, y, WindowWidth, height);
    [button addTarget:self action:@selector(ButClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
