//
//  ViewController.m
//  AlertViewList
//
//  Created by 刘凡 on 2017/7/27.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "ViewController.h"
#import "KNTableAlertView.h"
#import "KNTableCenterAlertView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 表格
 */
@property (nonatomic,strong) UITableView *tableView;

//显示表格
@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;

}


#pragma 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}



#pragma mark - 设置总共的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    
}

#pragma mark - 设置数据
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

}

#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
          
            [self CreateKNTableAlertView];
            
        }
            break;
        case 1:
        {
            [self CreateKNTableCenterAlertView];
        }
            break;
        default:
            break;
    }
}



//创建表格形式的弹窗
-(void)CreateKNTableAlertView{
    
    [KNTableAlertView ShowWithTitle:@"这是标题" DestructiveTitle:nil OtherTitles:@[@"1",@"2",@"3"] block:^(NSInteger index) {
       
        [self CreateAlertView:index];
    }];
    
}

//表格中间弹出式
-(void)CreateKNTableCenterAlertView{
    
    //定义一个图片数组
    NSArray <UIImage *> * images =@[[UIImage imageNamed:@"right_menu_addFri"],[UIImage imageNamed:@"right_menu_facetoface"],[UIImage imageNamed:@"right_menu_multichat"],[UIImage imageNamed:@"right_menu_payMoney"]
                                    ];
  [KNTableCenterAlertView ShowWithTitle:@"这是标题" Images:images ListTitles:@[@"添加好友",@"面对面快传",@"发起多人聊天",@"付款",@"扫一扫"] block:^(NSInteger index) {
        [self CreateAlertView:index];
    }];
    
    
    
}

-(void)CreateKNMeunAlertView{
    
}



-(void)CreateAlertView:(NSInteger)index{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"这是选择的下标" message:[NSString stringWithFormat:@"%ld",index]
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:alert1];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(NSArray *)dataArray{
    if(!_dataArray)
    {
        _dataArray = [NSArray arrayWithObjects:@"由下向上弹出式表格选择",@"中间弹出式表格", nil];
        
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
