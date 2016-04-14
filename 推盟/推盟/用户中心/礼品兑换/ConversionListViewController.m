//
//  ConversionListViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ConversionListViewController.h"
#import "ConversionListTableViewCell.h"
#import "GiftRecordModel.h"

@interface ConversionListViewController ()<SNRefreshDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SNRefreshTableView *myTableView;
@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation ConversionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"兑换记录";
    
    _data_array = [NSMutableArray array];
    
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    _myTableView.rowHeight = 120;
    _myTableView.isHaveMoreData = YES;
        
    [self loadListData];
    [self startLoading];
}

#pragma mark  ------   网络请求
-(void)loadListData{
    
    __weak typeof(self) wself = self;
    NSLog(@"-----%@",[NSString stringWithFormat:@"%@&user_id=%@&page=%d",GIFT_RECORD_LIST,[ZTools getUid],_myTableView.pageNum]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@&page=%d",GIFT_RECORD_LIST,[ZTools getUid],_myTableView.pageNum] success:^(id data) {
        [wself endLoading];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = data[@"status"];
            if (status.intValue == 1) {
                if (wself.myTableView.pageNum == 1) {
                    wself.myTableView.isHaveMoreData = YES;
                    [wself.data_array removeAllObjects];
                }
                NSArray * array = [data objectForKey:@"record"];
                if (array && [array isKindOfClass:[NSArray class]]) {
                    for (NSDictionary * dic in array) {
                        GiftRecordModel * model = [[GiftRecordModel alloc] initWithDictionary:dic];
                        [wself.data_array addObject:model];
                    }
                    
                }else{
                    wself.myTableView.isHaveMoreData = NO;
                }
                [wself.myTableView finishReloadigData];
            }else{
                [ZTools showMBProgressWithText:[data objectForKey:@"errorinfo"] WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [wself.myTableView finishReloadigData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversionListTableViewCell*cell = (ConversionListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    [cell setInfomationWith:_data_array[indexPath.row]];
    
    return cell;
}

- (void)loadNewData{
    [self loadListData];
}
- (void)loadMoreData{
    [self loadListData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    GiftRecordModel*model = [_data_array objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showGiftDetailVCSegue" sender:model.gift_id];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showGiftDetailVCSegue"]) {
        UIViewController * viewController = segue.destinationViewController;
        [viewController setValue:sender forKey:@"gift_id"];
    }
}


@end
