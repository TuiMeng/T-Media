//
//  MOrderListController.m
//  推盟
//
//  Created by joinus on 16/4/25.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MOrderListController.h"
#import "MovieOrderListModel.h"
#import "MOrderCell.h"
#import "UIAlertView+Blocks.h"
#import "MCinemaScheduleViewController.h"


@interface MOrderListController ()<UITableViewDataSource,SNRefreshDelegate>{
    
}

@property(nonatomic,strong)SNRefreshTableView   * myTableView;
@property(nonatomic,strong)NSMutableArray       * dataArray;
@property(nonatomic,assign)int                  totalPage;
@end

@implementation MOrderListController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.title_label.text = @"我的订单";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"联系客服"];
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"backImage"];
    
    
    _dataArray = [NSMutableArray array];
    
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0,
                                                                                           0,
                                                                                           DEVICE_WIDTH,
                                                                                           DEVICE_HEIGHT-64)
                                                                   showLoadMore:YES];
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    _myTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    _myTableView.pageNum            = 1;
    _myTableView.isHaveMoreData     = YES;
    [self.view addSubview:_myTableView];
    
    [self loadOrderData];
}

-(void)leftButtonTap:(UIButton *)sender{
    for (UIViewController * vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[MCinemaScheduleViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonTap:(UIButton *)sender{
    
    UIAlertView * alertView = [UIAlertView showWithTitle:@"400-666-9696" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"呼叫"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:400-666-9696"]];
        }
    }];
    [alertView show];
}

#pragma mark -----  网络请求
-(void)loadOrderData{
    __WeakSelf__ wself = self;
    
    [self startLoading];
    
    NSDictionary * dic = @{@"uid":[ZTools getUid],@"page":@(_myTableView.pageNum)};
    
    [[ZAPI manager] sendPost:MOVIE_ORDER_LIST_URL myParams:dic success:^(id data) {
        [wself endLoading];
        if (wself.myTableView.pageNum == 1) {
            [wself.dataArray removeAllObjects];
        }
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                wself.totalPage = [data[@"total"] intValue];
                
                NSArray * array = data[@"user"];
                if ([array isKindOfClass:[NSArray class]]) {
                    for (NSDictionary * item in array) {
                        MovieOrderListModel * model = [[MovieOrderListModel alloc] initWithDictionary:item];
                        [wself.dataArray addObject:model];
                    }
                }
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        
        [wself.myTableView finishReloadigData];
        
    } failure:^(NSError *error) {
        [wself.myTableView finishReloadigData];
        [wself endLoading];
    }];
}
//重新发送取票码
-(void)sendTicketCodeWithPayno:(NSString *)pay_no{
    __WeakSelf__ wself = self;
    [self startLoading];
    [[ZAPI manager] sendMoviePost:MOVIE_SEND_TICKERCODE_URL myParams:@{@"pay_no":pay_no} success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                [ZTools showMBProgressWithText:@"取票码已发送到您的手机上，请注意查收" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }else{
            [ZTools showMBProgressWithText:@"请求失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
        
    } failure:^(NSError *error) {
        [wself endLoading];
        [ZTools showMBProgressWithText:@"请求失败,请检查当前网络状况" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}


#pragma mark -----  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    MOrderCell * cell = (MOrderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.backgroundColor = RGBCOLOR(245, 245, 245);
        cell.backgroundColor = RGBCOLOR(245, 245, 245);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MovieOrderListModel * model = _dataArray[indexPath.row];
    [cell setInfomationWithOrderModel:model];
    
    __WeakSelf__ wself = self;
    
    [cell getTicketCodeClicked:^(NSString *orderId){
        [wself sendTicketCodeWithPayno:orderId];
    }];
    
    return cell;
}

#pragma mark -----  SNRefreshTableViewDelegate
-(void)loadNewData{
    [self loadOrderData];
}
- (void)loadMoreData{
    if (_totalPage <= _myTableView.pageNum) {
        _myTableView.isHaveMoreData = NO;
        [_myTableView finishReloadigData];
        return;
    }
    _myTableView.isHaveMoreData = YES;
    [self loadOrderData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 210;
}


@end
