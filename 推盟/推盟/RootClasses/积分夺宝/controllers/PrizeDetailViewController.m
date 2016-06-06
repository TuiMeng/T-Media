//
//  PrizeDetailViewController.m
//  推盟
//
//  Created by joinus on 16/6/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeDetailViewController.h"

@interface PrizeDetailViewController ()<SNRefreshDelegate,UITableViewDataSource>

@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)NSMutableArray       * dataArray;

@property(nonatomic,strong)SDCycleScrollView    * cycle_scrollView;

@end

@implementation PrizeDetailViewController

-(void)viewDidLoad{
    
    
}

#pragma mark ---  创建主视图
-(void)createMainView{
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}
-(void)createSectionView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    
    UIView * prizeInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, 0)];
    prizeInfoBackView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    prizeInfoBackView.layer.borderWidth = 0.5;
    [headerView addSubview:prizeInfoBackView];
    
    //轮播图

    UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, prizeInfoBackView.width-10, [ZTools autoHeightWith:180])];
    headerImageView.backgroundColor = [UIColor redColor];
    [prizeInfoBackView addSubview:headerImageView];
    
    for (int i = 0; i < 2; i++) {
        
    }
    
    
    
    
    
    
    
    self.myTableView.tableHeaderView = headerView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

-(void)loadNewData{
    
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 44;
}




@end
