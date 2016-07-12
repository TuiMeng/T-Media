//
//  PrizeListView.m
//  推盟
//
//  Created by joinus on 16/6/3.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeListView.h"
#import "PrizeCell.h"
#import "PrizeModel.h"
#import "PrizeDetailViewController.h"
#import "UIAlertView+Blocks.h"
#import "PersonalInfoViewController.h"

@interface PrizeListView ()<SNRefreshDelegate,UITableViewDataSource>{
    
}


@property(nonatomic,strong)SNRefreshTableView   * myTableView;


@property(nonatomic,strong)PrizeModel           * model;

@end


@implementation PrizeListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMainView];
    }
    return self;
}

-(PrizeModel *)model{
    if (_model == nil) {
        _model = [PrizeModel sharedInstance];
    }
    return _model;
}


-(void)getData{
    __WeakSelf__ wself = self;
    [self.model loadListDataWithPage:_myTableView.pageNum withSuccess:^(NSMutableArray *array) {
        
        wself.dataArray = array;
        wself.myTableView.isHaveMoreData = YES;
        [wself.myTableView finishReloadigData];
    } withFailure:^(NSString *error) {
        if ([error isEqualToString:@"没有更多数据"]) {
            wself.myTableView.isHaveMoreData = NO;
        }else{
            [ZTools showMBProgressWithText:error WihtType:MBProgressHUDModeText addToView:wself isAutoHidden:YES];
        }
        [wself.myTableView finishReloadigData];
    }];
}

#pragma mark ---  创建主视图
-(void)createMainView{
    
    _dataArray = [NSMutableArray array];
    
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:self.bounds showLoadMore:YES];
    _myTableView.isHaveMoreData = YES;
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [self addSubview:_myTableView];
}


#pragma mark -------  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setInfomationWithPrizeModel:_dataArray[indexPath.row]];
    
    return cell;
}

-(void)loadNewData{
    [self getData];
}
- (void)loadMoreData{
    [self getData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![ZTools isLogIn]) {
        [[LogInView sharedInstance] loginShowWithSuccess:^{

        }];
        return;
    }
    
    
    PrizeDetailViewController * detailVC = [[PrizeDetailViewController alloc] init];
    detailVC.model = _dataArray[indexPath.row];
    [_viewController.navigationController pushViewController:detailVC animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 208;
}


@end
