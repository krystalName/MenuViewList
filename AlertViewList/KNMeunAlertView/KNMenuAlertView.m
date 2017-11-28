//
//  KNMeunAlertView.m
//  AlertViewList
//
//  Created by 刘凡 on 2017/8/1.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "KNMenuAlertView.h"
#import "UIView+KNViewExtend.h"

#define kMenuTag 201712
#define kMargin 8
#define kTriangleHeight 10 // 三角形的高
#define kRadius 5 // 圆角半径
#define KDefaultMaxValue 6  // 菜单项最大值

@interface KNMenuAlertView ()<UITableViewDelegate,UITableViewDataSource>

//表格
@property(nonatomic, strong)UITableView * menuTableView;

/**
 标签数组
 */
@property (nonatomic, strong)NSArray <NSString *> * listTitles;

/**
 图片数组
 */
@property (nonatomic, strong) NSArray <UIImage * >* images;

//箭头位置
@property(nonatomic, assign)CGFloat arrowPointX;

@end

@implementation KNMenuAlertView


+(KNMenuAlertView *)createViewWiththImages:(NSArray<UIImage *> *)images ListTitles:(NSArray<NSString *> *)listTitles block:(IteomsClickBlock)block
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    KNMenuAlertView *menuView = [[KNMenuAlertView alloc]initWithFrame:CGRectMake(0, 0, 120, 40 * listTitles.count)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    menuView.listTitles = listTitles;
    menuView.images = images;
    menuView.itemsClickBlock = block;
    [menuView initView];
    menuView.tag = kMenuTag;
    [window addSubview:menuView];
    return menuView;
}

-(void)initView{

    self.arrowPointX = self.width * 0.5;
    [self addSubview:self.menuTableView];
    self.menuTableView.frame = CGRectMake(0, kTriangleHeight, self.width, self.height);
    self.height = self.menuTableView.height + kTriangleHeight * 2 - 0.5;
    
    
    CAShapeLayer *lay = [self getBorderLayer];
    self.layer.mask = lay;
    

}

#pragma mark --- 关于菜单展示
- (void)displayAtPoint:(CGPoint)point{
    
    point = [self.superview convertPoint:point toView:self.window];
    self.layer.affineTransform = CGAffineTransformIdentity;
    [self adjustPosition:point]; // 调整展示的位置 - frame
    
    // 调整箭头位置
    if (point.x <= kMargin + kRadius + kTriangleHeight * 0.7) {
        _arrowPointX = kMargin + kRadius;
    }else if (point.x >= KSCREEN_WIDTH - kMargin - kRadius - kTriangleHeight * 0.7){
        _arrowPointX = self.width - kMargin - kRadius;
    }else{
        _arrowPointX = point.x - self.x;
    }
    
    // 调整anchorPoint
    CGPoint aPoint = CGPointMake(0.5, 0.5);
    if (CGRectGetMaxY(self.frame) > KSCREEN_HEIGHT) {
        aPoint = CGPointMake(_arrowPointX / self.width, 1);
    }else{
        aPoint = CGPointMake(_arrowPointX / self.width, 0);
    }
    
    // 调整layer
    CAShapeLayer *layer = [self getBorderLayer];
    if (self.max_Y > KSCREEN_HEIGHT) {
        layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        layer.transform = CATransform3DRotate(layer.transform, M_PI, 0, 0, 1);
        self.y = point.y - self.height;
    }
    
    // 调整frame
    CGRect rect = self.frame;
    self.layer.anchorPoint = aPoint;
    self.frame = rect;
    
    self.layer.mask = layer;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;

        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)adjustPosition:(CGPoint)point{
    self.x = point.x - self.width * 0.5;
    self.y = point.y + kMargin;
    if (self.x < kMargin) {
        self.x = kMargin;
    }else if (self.x > KSCREEN_WIDTH - kMargin - self.width){
        self.x = KSCREEN_WIDTH - kMargin - self.width;
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
}



+(void)showMenuAtPoint:(CGPoint)point
{
    KNMenuAlertView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    
}


+(void)hiddenView
{
    
}


#pragma 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}


#pragma mark - 设置总共的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listTitles.count;
}



#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


- (CAShapeLayer *)getBorderLayer{
    // 上下左右的圆角中心点
    CGPoint upperLeftCornerCenter = CGPointMake(kRadius, kTriangleHeight + kRadius);
    CGPoint upperRightCornerCenter = CGPointMake(self.width - kRadius, kTriangleHeight + kRadius);
    CGPoint bottomLeftCornerCenter = CGPointMake(kRadius, self.height - kTriangleHeight - kRadius);
    CGPoint bottomRightCornerCenter = CGPointMake(self.width - kRadius, self.height - kTriangleHeight - kRadius);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath addArcWithCenter:upperLeftCornerCenter radius:kRadius startAngle:M_PI endAngle:M_PI * 3 * 0.5 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(_arrowPointX - kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(_arrowPointX, 0)];
    [bezierPath addLineToPoint:CGPointMake(_arrowPointX + kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(self.width - kRadius, kTriangleHeight)];
    [bezierPath addArcWithCenter:upperRightCornerCenter radius:kRadius startAngle:M_PI * 3 * 0.5 endAngle:0 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(self.width, self.height - kTriangleHeight - kRadius)];
    [bezierPath addArcWithCenter:bottomRightCornerCenter radius:kRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(kRadius, self.height - kTriangleHeight)];
    [bezierPath addArcWithCenter:bottomLeftCornerCenter radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath closePath];
    borderLayer.path = bezierPath.CGPath;
    return borderLayer;
}




#pragma mark - 懒加载
-(UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.bounces = NO;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.sectionHeaderHeight = 0;
        _menuTableView.sectionFooterHeight = 0;
        _menuTableView.estimatedRowHeight = 40;
    }
    return _menuTableView;
}


@end
