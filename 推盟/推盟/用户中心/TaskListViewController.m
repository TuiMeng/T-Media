//
//  TaskListViewController.m
//  推盟
//
//  Created by joinus on 15/12/22.
//  Copyright © 2015年 joinus. All rights reserved.
//

#import "TaskListViewController.h"
#import "PersonalCenterCell.h"

@interface TaskListViewController ()<UITableViewDataSource,SNRefreshDelegate>{
    //当前选中项（抢单中任务/已完成任务）
    int current_index;
}


@property (weak, nonatomic) IBOutlet SNRefreshTableView *myTableView;

@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:@[@"抢单中的任务",@"已完成的任务"]];
    segment.frame = CGRectMake(0, 0, [ZTools autoWidthWith:180], 30);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    _data_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],nil];
    
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = nil;
    _myTableView.tableHeaderView.frame = CGRectMake(0,0,0,300);
    
    current_index = 0;
    [self loadTaskDataWithType:!current_index];
}

/**
 *  获取抢单任务列表数据
 *
 *  @param aType 任务类型（0:历史抢单任务；1：抢单中任务）
 */
-(void)loadTaskDataWithType:(int)aType{
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"加载中..." WihtType:MBProgressHUDModeIndeterminate addToView:_myTableView isAutoHidden:NO];
    NSLog(@"--------%@",[NSString stringWithFormat:@"%@&user_id=%@&task_status=%d",GET_USER_TASKS_URL,[ZTools getUid],aType]);
    __weak typeof(self)bself = self;
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@&task_status=%d",GET_USER_TASKS_URL,[ZTools getUid],aType] success:^(id data) {
        
        [hud hide:YES];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:@"status"] intValue] == 1)
            {
                [[bself.data_array objectAtIndex:aType] removeAllObjects];
                
                NSArray * array = [data objectForKey:@"task"];
                
                for (NSDictionary * dic in array)
                {
                    UserTaskModel * model = [[UserTaskModel alloc] initWithDictionary:dic];
                    [[bself.data_array objectAtIndex:aType] addObject:model];
                }
            }else{
                [ZTools showErrorWithStatus:[data objectForKey:@"status"] InView:self.view isShow:YES];
            }
        }
        [bself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [bself.myTableView finishReloadigData];
    }];
}

- (void)segmentControlChanged:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex != current_index) {
        current_index = (int)sender.selectedSegmentIndex;
        if ([_data_array[!current_index] count] > 0) {
            [_myTableView finishReloadigData];
            return;
        }
        [self loadTaskDataWithType:!current_index];
    }
}



#pragma mark ***********  UITableView Delegate  *******************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data_array[!current_index] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalCenterCell * cell = (PersonalCenterCell*)[tableView dequeueReusableCellWithIdentifier:@"personalCenterIdentifier"];
    UserTaskModel * model = _data_array[!current_index][indexPath.row];
    [cell setInfomationWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark  ***********  SNRefreshTableViewDelegate
- (void)loadNewData{
    [self loadTaskDataWithType:current_index];
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
