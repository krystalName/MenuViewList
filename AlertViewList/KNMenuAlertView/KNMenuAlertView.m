//
//  KNMenuAlertView.m
//  AlertViewList
//
//  Created by 刘凡 on 2017/8/1.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "KNMenuAlertView.h"
#import "UIView+KNViewExtend.h"
#import "KNMenuViewCell.h"

#define kMenuTag 201712
#define kCoverViewTag 201722
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
@property (nonatomic, strong)NSMutableArray <NSString *> * listTitles;

/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray <UIImage * >* images;

//箭头位置
@property(nonatomic, assign)CGFloat arrowPointX;

//背景View
@property(nonatomic, strong)UIView * backView;


@end

@implementation KNMenuAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self initView];
    }
    return self;
}


+(KNMenuAlertView *)createViewWiththImages:(NSArray<UIImage *> *)images ListTitles:(NSArray<NSString *> *)listTitles block:(IteomsClickBlock)block
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    

    NSInteger NScount = listTitles.count;
    if (NScount > KDefaultMaxValue) {
        NScount = KDefaultMaxValue ;
    }
    
 
    KNMenuAlertView *menuView = [[KNMenuAlertView alloc]initWithFrame:CGRectMake(0, 0, 120, (40 * NScount)+(kTriangleHeight * 2))];\
    
    //如果图片数组比列表数组少的时候。 添加一个空的图片
     menuView.listTitles = [NSMutableArray arrayWithArray:listTitles];

    
    //如果图片数组比列表数组少的时候。 添加一个空的图片
    menuView.images = [NSMutableArray arrayWithArray:images];
    if (images.count < listTitles.count ) {
        NSInteger maxCont = listTitles.count - images.count ;
        for (int i = 0; i <maxCont; i++) {
            [menuView.images addObject:[UIImage new]];
        }
    }
    
    
    menuView.itemsClickBlock = block;
    [menuView initView];
    menuView.tag = kMenuTag;
    return menuView;
    
}

-(void)initView{
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.arrowPointX = self.width * 0.5;
    self.menuTableView.frame = CGRectMake(0, kTriangleHeight, self.width, self.height - kTriangleHeight * 2);
    self.alpha = 0;    
    //背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    backView.alpha = 0;
    backView.tag = kCoverViewTag;
    _backView = backView;
    [window addSubview:backView];
    
    //添加箭头
    CAShapeLayer *lay = [self getBorderLayer];
    self.layer.mask = lay;
    
    //添加表格
    [self addSubview:self.menuTableView];
    [window addSubview:self];
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
        _backView.alpha = 0.3;
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

- (void)tap:(UITapGestureRecognizer *)sender{
    [self hiddenMenu];
}

+(void)showMenuAtPoint:(CGPoint)point
{
    KNMenuAlertView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    [menuView displayAtPoint:point];
}




#pragma 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}


#pragma mark - 设置总共的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listTitles.count;
}

#pragma mark - 赋值
-(void)tableView:(UITableView *)tableView willDisplayCell:(KNMenuViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell SetCellValueWithImage:self.images[indexPath.row] AndLable:self.listTitles[indexPath.row]];
    
}


#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KNMenuViewCell class])];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.itemsClickBlock) {
        [self hiddenMenu];
        self.itemsClickBlock(self.listTitles[indexPath.row], indexPath.row+1);
    }

}

- (void)hiddenMenu{
    self.menuTableView.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        _backView.alpha = 0;
        self.alpha = 0;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.bounces = NO;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.estimatedRowHeight = 40;
        [_menuTableView registerClass:[KNMenuViewCell class] forCellReuseIdentifier:NSStringFromClass([KNMenuViewCell class])];
    }
    return _menuTableView;
}


@end
