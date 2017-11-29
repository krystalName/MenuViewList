//
//  KNMenuViewCell.m
//  AlertViewList
//
//  Created by 刘凡 on 2017/11/29.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "KNMenuViewCell.h"
#import "UIView+KNViewExtend.h"

@interface KNMenuViewCell()

@property(nonatomic, strong)UIImageView *iConImageView;
@property(nonatomic, strong)UILabel *contentLbale;
@property(nonatomic, strong) UIView *lienView;

@end


@implementation KNMenuViewCell



#pragma mark - 初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.iConImageView];
        [self.contentView addSubview:self.contentLbale];
        [self.contentView addSubview:self.lienView];
    }
    return self;
}

#pragma mark - 赋值
-(void)SetCellValueWithImage:(UIImage *)iconImage AndLable:(NSString *)lable{
    
    [self.iConImageView setImage:iconImage];
    self.contentLbale.text = lable;
    
    [self layoutCellUI];
}


#pragma mark - 布局

-(void)layoutCellUI{
    
    self.iConImageView.frame = CGRectMake(10, self.contentView.height / 2 - 15 , 30, 30);
    self.contentLbale.frame = CGRectMake( 40, self.contentView.height / 2 - 7 , self.contentView.width - 50, 15);
    self.lienView.frame = CGRectMake(0, self.contentView.height - 0.5 , self.contentView.width, 0.5);
    
}

#pragma mark - 懒加载


-(UIImageView *)iConImageView{
    if (!_iConImageView) {
        _iConImageView = [[UIImageView alloc]init];
        _iConImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_iConImageView sizeToFit];
    }
    return _iConImageView;
}

-(UILabel *)contentLbale{
    if (!_contentLbale) {
        _contentLbale = [[UILabel alloc]init];
        _contentLbale.textColor = [UIColor lightTextColor];
        _contentLbale.font = [UIFont systemFontOfSize:13];
    }
    return _contentLbale;
}

-(UIView *)lienView{
    if (!_lienView) {
        _lienView = [[UIView alloc]init];
        _lienView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lienView;
}



@end
