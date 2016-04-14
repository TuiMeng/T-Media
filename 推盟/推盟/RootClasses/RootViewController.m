//
//  RootViewController.m
//  推盟
//
//  Created by joinus on 15/7/28.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "RootViewController.h"
#import "SListTopBarScrollView.h"
#import "RootTaskListModel.h"
#import "RootTaskListTableViewCell.h"
#import "ShareViewController.h"
#import "FocusImageModel.h"
#import "RootTopTitleModel.h"
#import "LogInViewController.h"
#import "TaskInfo.h"
#import "AppDelegate.h"
#import "RootMovieView.h"
#import "MovieCityViewController.h"

@interface RootViewController ()<SNRefreshDelegate,UITableViewDataSource,CLLocationManagerDelegate,SDCycleScrollViewDelegate>{
    BOOL                isShowCycleView;
    /**
     *  选择地区按钮
     */
    UIButton            * left_button;
    /**
     *  当前显示的第几页
     */
    int                 currentPage;
    
    CLLocationManager   * locationManager;
    //记录取到数据库第几条数据
    int                 get_sql_index;
    //记录每个栏目读到第几条数据
    int                 sqlite_index[255];
    /**
     *  记录ip地址所在地
     */
    NSString            * ip_area_string;
    /**
     *  记录手机号码所在地
     */
    NSString            * phone_num_area_string;
    /**
     *  记录根据gps获取到的所在地
     */
    NSString            * location_city;
    
    BOOL                area_success_load;
}

@property(nonatomic,strong)NSMutableArray           * data_array;
@property(nonatomic,strong)SListTopBarScrollView    * topScrollView;
@property(nonatomic,strong)SNRefreshTableView       * myTableView;
@property(nonatomic,strong)UIScrollView             * myScrollView;
@property(nonatomic,strong)NSMutableArray           * c_array;
@property(nonatomic,strong)NSMutableArray           * focus_image_array;
@property(nonatomic,strong)NSMutableArray           * focus_title_array;
@property(nonatomic,strong)NSMutableArray           * top_title_array;
@property(nonatomic,strong)NSMutableArray           * top_array;
@property(nonatomic,strong)NSMutableArray           * contentViews;
/**
 *  所有在线任务
 */
@property(nonatomic,strong)NSMutableArray           * online_task_array;

@end

@implementation RootViewController

-(void)createLeftItem{
    left_button = [ZTools createButtonWithFrame:CGRectMake(0, 0, 60, 44) title:@"北京" image:[UIImage imageNamed:@"seller_bottom_arrow_image"]];
    left_button.adjustsImageWhenHighlighted = NO;
    [left_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    left_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [left_button setImage:[UIImage imageNamed:@"seller_top_arrow_image"] forState:UIControlStateSelected];
    
    CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:@"北京" WithWidth:left_button.width];
    [left_button setImageEdgeInsets:UIEdgeInsetsMake(0, (size.width+left_button.width)/2, 0, 0)];
    [left_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [left_button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_button];
}

-(void)leftButtonClicked:(UIButton *)button{
    left_button.selected = !left_button.selected;
    MovieCityViewController * viewController = [[MovieCityViewController alloc] init];
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.current_city = @"北京";
    [self presentViewController:navc animated:YES completion:nil];
    
    __weak typeof(self)wself = self;
    [viewController selectedCityWithCityBlock:^(SubCityModel *model) {
        [button setTitle:model.cityName forState:UIControlStateNormal];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"root_personal_center_image"];
    //侧边栏，暂时隐藏
    /*
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"root_left_image"];
     */
    /*
    //排行榜
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"root_ranking_image"];
     */
    [self createLeftItem];
    self.title_label.text = @"推盟";
    
    _data_array     = [NSMutableArray array];
    _contentViews   = [NSMutableArray array];
    location_city   = [ZTools getGPSAddress];
    
    _myScrollView           = [[UIScrollView alloc] initWithFrame:CGRectMake(0,45,DEVICE_WIDTH,DEVICE_HEIGHT-64-45)];
    _myScrollView.delegate  = self;
    _myScrollView.pagingEnabled = YES;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.bounces   = YES;
    _myScrollView.scrollsToTop = NO;
    [self.view addSubview:_myScrollView];
    
    [self setupLocationManager];
    [self loadTitlesData];
    //自动更新
    [UMCheckUpdate checkUpdate:@"发现新版本" cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即去更新" appkey:@"54903d31fd98c544f3000e17" channel:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut:) name:@"userLogOut" object:nil];
    
    //判断是否跳转到广告页
    NSString * ad_link = [[NSUserDefaults standardUserDefaults] objectForKey:@"adlink"];
    if ([[ZTools replaceNullString:ad_link WithReplaceString:@""] length] > 0) {
        SWebViewController * webVC = [[SWebViewController alloc] init];
        webVC.url = ad_link;
        [self.navigationController pushViewController:webVC animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"adlink"];
    }
    
    [self getIpAddress];
    
    
    NSLog(@"ip--%@\n phone--%@\n gps-%@",[ZTools getIPAddress],[ZTools getPhoneNumAddress],location_city);
}

-(void)getIpAddress{
//    http://ip.taobao.com/service/getIpInfo2.php?ip=myip
    [[ZAPI manager] sendGet:@"http://ip.taobao.com/service/getIpInfo2.php?ip=myip" success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSDictionary * item = [data objectForKey:@"data"];
            NSString * area = item[@"region"];
            if ([[ZTools replaceNullString:area WithReplaceString:@""] length]) {
                [[NSUserDefaults standardUserDefaults] setObject:[ZTools CutAreaString:area] forKey:IP_ADRESS];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -----   排行榜
-(void)leftButtonTap:(UIButton *)sender{
    //侧边栏暂时隐藏
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

    [self performSegueWithIdentifier:@"showRankingSegue" sender:nil];
}
#pragma mark ------   个人中心
-(void)rightButtonTap:(UIButton *)sender{
    if (![ZTools isLogIn]) {
        [self performSegueWithIdentifier:@"showLoginSegue" sender:@"personal"];
    }else{
        [self performSegueWithIdentifier:@"showPersonalCenterSegue" sender:nil];
    }
}

#pragma mark ---  退出登陆  刷新数据
-(void)logOut:(NSNotification*)sender{
    [_data_array removeAllObjects];
    [_contentViews removeAllObjects];
    _myScrollView.contentOffset = CGPointZero;
    for (UIView * view in _myScrollView.subviews) {
        [view removeFromSuperview];
    }
    currentPage = 0;
    [self loadTitlesData];
}
#pragma mark --------------  网络请求  -----------------
/*
//获取在线数据
-(void)loadOnLineTaskListData{

    __weak typeof(self)wself = self;
    RootTopTitleModel*model = _top_array[currentPage];
    SNRefreshTableView * tableView = _contentViews[currentPage];
    int page = currentPage;
    if (currentPage != 0) {
        [_online_task_array removeAllObjects];
        NSArray * array = [TaskInfo MR_findByAttribute:@"column_name" withValue:model.column_name];
        
        for (TaskInfo * info in array) {
            NSLog(@"info.name -----   %@",info.column_name);
            [_online_task_array addObject:info];
        }
        
        [tableView finishReloadigData];
        
    }else{
        [_online_task_array removeAllObjects];
        NSArray * array = [TaskInfo MR_findAll];
        
        for (TaskInfo * info in array) {
            [_online_task_array addObject:info];
        }
        
        [tableView finishReloadigData];
    }
    
    NSLog(@"url ---  %@",[NSString stringWithFormat:@"%@&user_id=%@&column_id=%@&city=%@&page=1",GET_ALL_ONLINE_TASK_URL,[ZTools getUid],model.id,location_city]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@&column_id=%@&city=%@&page=1",GET_ALL_ONLINE_TASK_URL,[ZTools getUid],model.id,location_city] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            tableView.isHaveMoreData = YES;
            if ([[data objectForKey:@"status"] intValue] == 1) {
                NSArray * array = [data objectForKey:@"task_list"];
                
                if (array && [array isKindOfClass:[NSArray class]]) {
                    
//                    [wself taskDataCacheWithArray:array];
//                    [wself handleOnlineTaskDataWithDictionary:array WithTableView:tableView WithTitleModel:model WithPage:page];
//                    for (NSDictionary * aDic in array) {
//                        //[wself handleOnlineTaskDataWithDictionary:aDic WithTableView:tableView];
//                    }
                }
            }
        }
        
        [tableView finishReloadigData];
        
    } failure:^(NSError *error) {
        [ZTools showMBProgressWithText:@"请求超时..." WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        [(SNRefreshTableView*)[wself.contentViews objectAtIndex:currentPage] finishReloadigData];
    }];
}
 */
//获取已结束任务数据
-(void)loadOffLineTaskListData{
    
    __weak typeof(self)wself = self;
    RootTopTitleModel*model = _top_array[currentPage];
    SNRefreshTableView * tableView = _contentViews[currentPage];
    
    //最后一条任务id
    NSString * task_id = @"";
    //当前选中的栏目
    int page = currentPage;
    int count = (int)[_data_array[currentPage] count];
    if (count) {
        RootTaskListModel * obj = [_data_array[currentPage] objectAtIndex:(count-1)];
        task_id = obj.encrypt_id;
    }
    
    NSLog(@"url ---  %@",[NSString stringWithFormat:@"%@&user_id=%@&column_id=%@&type=%@&page=%d&task_endid=%@",GET_ALL_OFFLINE_TASK_URL,[ZTools getUid],model.id,tableView.pageNum==1?@"1":@"2",20,task_id]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@&column_id=%@&type=%@&page=%d&task_endid=%@",GET_ALL_OFFLINE_TASK_URL,[ZTools getUid],model.id,tableView.pageNum==1?@"1":@"2",20,task_id] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            tableView.isHaveMoreData = YES;
            if (tableView.pageNum == 1) {
                [wself.data_array[page] removeAllObjects];
            }
            if ([[data objectForKey:@"status"] intValue] == 1) {
                NSArray * array = [data objectForKey:@"task_list"];
                if (array && [array isKindOfClass:[NSArray class]]) {
                    if (array.count < 20) {
                        tableView.isHaveMoreData = NO;
                    }else{
                        tableView.isHaveMoreData = YES;
                    }
                    [wself handleTaskDataWithDictionary:array WithTableView:tableView WithPage:page];
                }else{
                    tableView.isHaveMoreData = NO;
                }
            }else if([[data objectForKey:@"status"] intValue] == 200){
                tableView.isHaveMoreData = NO;
            }
        }else{
            tableView.isHaveMoreData = NO;
            [ZTools showMBProgressWithText:@"数据加载失败..." WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
        [tableView finishReloadigData];
    } failure:^(NSError *error) {
        [ZTools showMBProgressWithText:@"请求超时..." WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        [tableView finishReloadigData];
    }];
}
/*
//从数据库拿数据
-(void)loadTaskEndDataFromSQLiteWithTableView:(SNRefreshTableView*)tableView
                               WithColumnName:(NSString *)name
                                     withPage:(int)page{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskInfo" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create_time" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:20];
    [request setFetchOffset:get_sql_index];
    if (name.length != 0) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"column_name=%@",name]];
    }
    NSArray *rssTemp = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:request error:nil];
    
    if (rssTemp.count == 0) {
        get_sql_index = 0;
        [self loadOffLineTaskListData];
    }else{
        for (TaskInfo * info in rssTemp) {
            [_data_array[page] addObject:info];
        }
        [tableView finishReloadigData];
    }
}
*/
-(void)loadRootTaskListFile{
    int page = currentPage;
    SNRefreshTableView * tableView = _contentViews[page];
    //沙盒路径
    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/task.txt"];
    NSString *copy_path = [NSHomeDirectory() stringByAppendingString:@"/Documents/task_copy.txt"];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"https://www.twttmob.com/Apinew/include/index_list.txt?%@",[ZTools timechangeToDateline]] parameters:nil error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    
    __weak typeof(self)wself = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:savedPath];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"json:%@",json);
        if (json && [json isKindOfClass:[NSArray class]]) {
            [wself.data_array[page] removeAllObjects];
            tableView.isHaveMoreData = YES;
            [wself handleTaskDataWithDictionary:json WithTableView:tableView WithPage:page];
            //拷贝一份
            NSFileManager * fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:copy_path]) {
                [fileManager removeItemAtPath:copy_path error:nil];
            }
            BOOL result = [fileManager copyItemAtPath:savedPath toPath:copy_path error:nil];
            NSLog(@"copy_result ---  %d",result);
        }else{
            [ZTools showMBProgressWithText:@"加载失败，请重试" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
        [tableView finishReloadigData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败---- %@",error);
        [ZTools showMBProgressWithText:@"请求超时..." WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        [tableView finishReloadigData];
    }];
    
    [operation start];
}

-(void)loadFocusData{
    
    if (!_c_array) {
        _c_array = [NSMutableArray array];
        _focus_image_array = [NSMutableArray array];
        _focus_title_array = [NSMutableArray array];
    }
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&type=%@",GIFT_FOCUS_IMAGES_URL,@"root"] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [_c_array removeAllObjects];
            [_focus_title_array removeAllObjects];
            [_focus_image_array removeAllObjects];
            NSArray * array = [data objectForKey:@"Focus_img"];
            for (NSDictionary * dic in array) {
                
                FocusImageModel * model = [[FocusImageModel alloc] initWithDictionary:dic];
                [wself.c_array addObject:model];
                
                [wself.focus_image_array addObject:model.focus_img];
                [wself.focus_title_array addObject:model.title];
            }
            [wself setCycleView];
        }

    } failure:^(NSError *error) {
        
    }];
}
-(void)loadTitlesData{
    
    if (!_top_title_array) {
        _top_title_array = [NSMutableArray array];
        _top_array = [NSMutableArray array];
    }
    [_top_title_array removeAllObjects];
    [_top_array removeAllObjects];
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendGet:ROOT_TITLES_URL success:^(id data) {
        if ( data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            NSArray * array;
            if (status.intValue == 1) {
                array = [data objectForKey:@"column"];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"column_data"];
            }else{
                array = [[NSUserDefaults standardUserDefaults] objectForKey:@"column_data"];
            }
            [wself columnDataWith:array];
        }
    } failure:^(NSError *error) {
        NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"column_data"];
        [wself columnDataWith:array];
    }];
}
//打开程序首先读取沙河存储的任务缓存文件
-(void)loadTaskCacheFile{
    
    SNRefreshTableView * tableView = _contentViews[0];
    //沙盒路径
    NSString *file_path = [NSHomeDirectory() stringByAppendingString:@"/Documents/task_copy.txt"];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:file_path]) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:file_path];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (json && [json isKindOfClass:[NSArray class]]) {
            [self handleTaskDataWithDictionary:json WithTableView:tableView WithPage:0];
        }
    }
    [tableView reloadData];
    //拿到缓存数据，加载新数据
    [tableView showRefreshHeader:YES];
}
-(void)handleTaskDataWithDictionary:(NSArray*)array
                            WithTableView:(SNRefreshTableView *)tableView
                                 WithPage:(int)page{
    
    for (NSDictionary * item in array) {
        RootTaskListModel * model = [[RootTaskListModel alloc] initWithDictionary:item];
        
        if ((![model.area isEqualToString:@"全国"] && [[ZTools replaceNullString:model.area WithReplaceString:@""] length] != 0) && model.task_status.intValue == 1) {
            if ([model.area rangeOfString:[ZTools getIPAddress]].length == 0 && [model.area rangeOfString:[ZTools getPhoneNumAddress]].length == 0 && [model.area rangeOfString:[ZTools replaceNullString:location_city WithReplaceString:@""]].length == 0) {
                continue;
            }
        }
        
        [_data_array[page] addObject:model];
    }
}


/*
#pragma mark ----  处理首页任务文件数据（并缓存到数据库）
-(void)handleOnlineTaskDataWithDictionary:(NSArray*)array
                            WithTableView:(SNRefreshTableView *)tableView
                           WithTitleModel:(RootTopTitleModel*)title_model
                                 WithPage:(int)page{
    
    [_online_task_array removeAllObjects];
    
    tableView.isHaveMoreData = YES;
    
    for (NSDictionary * item in array) {
        
        NSMutableDictionary * aDic = [[NSMutableDictionary alloc] initWithDictionary:item];
        
        //数据添加到数组
        TaskInfo * model = [TaskInfo MR_createEntityInContext:nil];
        [model setValueWithDictionary:aDic];
        
        if (![model.area isEqualToString:@"全国"] || [[ZTools replaceNullString:model.area WithReplaceString:@""] length] == 0) {
            
            if ([model.area rangeOfString:[ZTools getIPAddress]].length == 0 && [model.area rangeOfString:[ZTools getIPAddress]].length == 0 && [model.area rangeOfString:[ZTools getIPAddress]].length == 0) {
                continue;
            }
        }
        
        NSArray * task = [TaskInfo MR_findByAttribute:@"encrypt_id" withValue:[aDic objectForKey:@"encrypt_id"]];
        if (model.task_status.intValue != 1)//把已结束的并且数据库不存在的任务存到数据库
        {
            if (!task || task.count == 0) {
                TaskInfo * model = [TaskInfo MR_createEntity];
                [model setValueWithDictionary:aDic];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
            sqlite_index[page]++;
            [_data_array[page] addObject:model];
        }else//在线的任务，看看数据库有没有相同的任务，如果有表示重新上线的，从数据库删除
        {
            if (task && task.count > 0) {
                for (TaskInfo * obj in task) {
                    [obj MR_deleteEntity];
                }
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
            
            [_online_task_array addObject:model];
            [_data_array[page] addObject:model];
        }
    }
    
    [tableView finishReloadigData];
    
    
}
//处理已结束任务数据
-(void)handleOfflineTaskDataWithArray:(NSArray*)array
                      WithCurrentPage:(int)page
                        WithTableView:(SNRefreshTableView*)tableView
                WithRootTopTitleModel:(RootTopTitleModel*)model{
    
    //如果是其他的栏目，并且请求第一页数据，如果没有数据，去数据库查找
    if (page != 0 && tableView.pageNum == 1 && array.count == 0) {
        
        NSArray * task_list = [TaskInfo MR_findAllSortedBy:@"create_time" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"column_name=%@",model.column_name]];
        if (!task_list || task_list.count == 0) {
            tableView.isHaveMoreData = NO;
        }else{
            for (TaskInfo * obj in task_list) {
                [_data_array[page] addObject:obj];
            }
        }
        return;
    }
    
    for (NSDictionary * item in array) {
        NSArray * task = [TaskInfo MR_findByAttribute:@"encrypt_id" withValue:[item objectForKey:@"encrypt_id"]];
        
        if ((!task || task.count == 0)) {
            if (page == 0) {
                NSLog(@"-------   %@",[item objectForKey:@"encrypt_id"]);
                TaskInfo * info = [TaskInfo MR_createEntity];
                [info setValueWithDictionary:item];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                
                info = nil;
                sqlite_index[page]++;
            }
        }else{
            sqlite_index[page]++;
        }
        
        TaskInfo * model = [TaskInfo MR_createEntityInContext:nil];
        [model setValueWithDictionary:item];
        [_data_array[page] addObject:model];
    }
}


#pragma mark ---  任务数据缓存
-(void)taskDataCacheWithArray:(NSArray*)array{

    
    for (NSDictionary * item in array) {
        NSArray * task = [TaskInfo MR_findByAttribute:@"encrypt_id" withValue:[item objectForKey:@"encrypt_id"]];
        if (!task || task.count == 0) {
            if ([item[@"task_status"] intValue] != 1) {
                TaskInfo * info = [TaskInfo MR_createEntity];
                [info setValueWithDictionary:item];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
    }
    
    NSArray * task_array = [TaskInfo MR_findAll];
    NSLog(@"task_array -------  %d",(int)task_array.count);
    
    for (TaskInfo * item in task_array) {
        NSLog(@"item.name ----   %@",item.task_name);
    }
    
    
    TaskInfo * object = [TaskInfo MR_findFirstOrderedByAttribute:@"task_name" ascending:NO];
    
    NSArray * column_array = [TaskInfo MR_findAllSortedBy:@"task_name" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"column_name=%@",@"电影"]];
    
    for (TaskInfo * item in task_array) {
        NSLog(@"item.name ----   %@",item.task_name);
    }
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskInfo" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"task_name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:10];
    [request setFetchOffset:10];
    NSArray *rssTemp = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:request error:nil];
    
    for (TaskInfo * info in rssTemp) {
        NSLog(@"name -=-=-==-=-=   %@",info.task_name);
    }
    
    [TaskInfo MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"column_name=%@",@"电影"] sortedBy:@"encrypt_id" ascending:YES];
    NSLog(@"id ------------   %@",object.encrypt_id);
 
}

#pragma mark ----  加载更多时，先判断有没有本地数据
-(void)loadMoreTaskListData{
    RootTopTitleModel*model = _top_array[currentPage];
    SNRefreshTableView * tableView = _contentViews[currentPage];
    
    if (currentPage == 0) {
        if (sqlite_index[currentPage]) {
            [self loadTaskEndDataFromSQLiteWithTableView:tableView
                                          WithColumnName:currentPage?model.column_name:@""
                                                withPage:currentPage];
        }else{
            [self loadOffLineTaskListData];
        }
    }else{
        [self loadOffLineTaskListData];
    }
}
*/
#pragma mark ----  任务读取缓存数据
-(void)ReadCacheTaskListDataWithTableView:(SNRefreshTableView*)tableView WithPage:(int)page{
    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/task.txt"];

    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:savedPath];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (json && [json isKindOfClass:[NSArray class]]) {
        for (NSDictionary * item in json) {
            RootTaskListModel * model = [[RootTaskListModel alloc] initWithDictionary:item];
            
            if ((![model.area isEqualToString:@"全国"] && [[ZTools replaceNullString:model.area WithReplaceString:@""] length] == 0) && model.task_status.intValue == 1) {
                
                if ([model.area rangeOfString:[ZTools getIPAddress]].length == 0 && [model.area rangeOfString:[ZTools getIPAddress]].length == 0 && [model.area rangeOfString:[ZTools getIPAddress]].length == 0) {
                    continue;
                }
            }
            
            [self.data_array[page] addObject:model];
        }
        [tableView finishReloadigData];
    }

}

#pragma mark - 处理标题数据
-(void)columnDataWith:(NSArray*)array{
    
    for (NSDictionary * dic in array) {
        
        RootTopTitleModel * model = [[RootTopTitleModel alloc] initWithDictionary:dic];
        [self.top_array addObject:model];
        [self.top_title_array addObject:model.column_name];
    }
    [self createMainViews];
    [self createTopTitleView];
}

-(void)createTopTitleView{
    
    _topScrollView = [[SListTopBarScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,45)];
    __weak typeof(self)wself = self;
    _topScrollView.scrollsToTop = NO;
    _topScrollView.btnWidth                 = DEVICE_WIDTH/4.0f-10;
    _topScrollView.lineWidth                = (DEVICE_WIDTH/4.0f-10)-20;
    _topScrollView.titleNormalColor         = [UIColor whiteColor];
    _topScrollView.titleSelectedColor       = DEFAULT_BACKGROUND_COLOR;
    _topScrollView.titleFont                = [ZTools returnaFontWith:15];
    _topScrollView.listBarItemClickBlock    = ^(NSString *itemName , NSInteger itemIndex){
        
        [wself exchangeColumnWithPage:(int)itemIndex];
    };
    [self.view addSubview:_topScrollView];
    _topScrollView.visibleItemList          = _top_title_array;
}
#pragma mark -----  栏目切换
-(void)exchangeColumnWithPage:(int)page{
    __weak typeof(self) wself = self;
    currentPage = page;
    id pre_tableView = self.contentViews[currentPage];
    id tableView = self.contentViews[page];
    
    [UIView animateWithDuration:.25 animations:^
     {
         wself.myScrollView.contentOffset = CGPointMake(DEVICE_WIDTH*page, 0);
     } completion:^(BOOL finished) {
         
         if ([tableView isKindOfClass:[RootMovieView class]]) {
             [(RootMovieView*)tableView loadMoiveData];
         }else{
             [(SNRefreshTableView*)pre_tableView setScrollsToTop:NO];
             
             [(SNRefreshTableView*)tableView setScrollsToTop:YES];
             if ([wself.data_array[currentPage] count] == 0) {
                 ///加载数据
                 [tableView showRefreshHeader:YES];
             }
         }
     }];
    
    if (page != 2) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        _myScrollView.height = DEVICE_HEIGHT-_topScrollView.height-64;
    }
}
#pragma mark -----  创建所有tableview
-(void)createMainViews{
    for (int i = 0; i < self.top_array.count; i++) {
        
        NSString * title = [_top_title_array objectAtIndex:i];
        [_data_array addObject:[NSMutableArray array]];
        if ([title isEqualToString:@"电影"]) {
            RootMovieView * movie_view = [[RootMovieView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*i, 0, DEVICE_WIDTH, self.myScrollView.height)];
            movie_view.viewController = self;
            [_myScrollView addSubview:movie_view];
            [_contentViews addObject:movie_view];
            
            /*
            __weak typeof(movie_view) wMovieView = movie_view;
            [movie_view setNavigationViewShow:^(BOOL isShow) {
                if (currentPage == 2) {
                    [self.navigationController setNavigationBarHidden:!isShow animated:YES];
                    [[UIApplication sharedApplication] setStatusBarHidden:!isShow withAnimation:UIStatusBarAnimationSlide];
                    _myScrollView.height = DEVICE_HEIGHT-_topScrollView.height;
                    wMovieView.height = DEVICE_HEIGHT - _topScrollView.height;
                    wMovieView.myTableView.height = wMovieView.height - wMovieView.top_view.height;
                }
            }];
             */
            
        }else{
            SNRefreshTableView * tableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*i,0,DEVICE_WIDTH,self.myScrollView.height) showLoadMore:YES];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.refreshDelegate = self;
            tableView.dataSource = self;
            tableView.isHaveMoreData = NO;
            tableView.tag = 1000 + i;
            tableView.backgroundColor = RGBCOLOR(237, 237, 237);
            tableView.scrollsToTop = NO;
            if (i==0) {
                tableView.scrollsToTop = YES;
            }
            
            [_myScrollView addSubview:tableView];
            [_contentViews addObject:tableView];
        }
        
    }
    
    [self loadTaskCacheFile];
    
    _myScrollView.contentSize = CGSizeMake(DEVICE_WIDTH*_top_array.count, 0);
}

-(void)setCycleView{
    
    _cycle_scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,40,DEVICE_WIDTH,[ZTools autoHeightWith:180]) imageURLStringsGroup:_focus_image_array];
    _cycle_scrollView.titlesGroup = _focus_title_array;
    _cycle_scrollView.delegate = self;
    _cycle_scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycle_scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycle_scrollView.autoScrollTimeInterval = 5.f;
    
    if (currentPage == 0) {
        UITableView * tableView = (UITableView*)[_myScrollView viewWithTag:1000];
        tableView.tableHeaderView = _cycle_scrollView;
    }
}
#pragma mark ------------------   Refresh delegate methods
- (void)loadNewData{
    if (currentPage == 0) {
        [self loadFocusData];
        [self loadRootTaskListFile];
    }else{
        [self loadOffLineTaskListData];
    }
}
- (void)loadMoreData{
    if ([_data_array[currentPage] count] != 0) {
        [self loadOffLineTaskListData];
    }
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RootTaskListModel * model = _data_array[currentPage][indexPath.row];
    [self performSegueWithIdentifier:@"ShowTaskDetailSegue" sender:model];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 25+[ZTools autoWidthWith:95];
}
#pragma mark ----------------   UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data_array[tableView.tag-1000] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    RootTaskListTableViewCell * cell = (RootTaskListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[RootTaskListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];//[[[NSBundle mainBundle] loadNibNamed:@"RootTaskListTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RootTaskListModel * model = _data_array[tableView.tag-1000][indexPath.row];
    [cell setInfoWith:model showTag:!currentPage WithShare:^{
        
        BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:LOGIN];
        
        if (!isLogIn) {
            [self performSegueWithIdentifier:@"showLoginSegue" sender:@"share"];
        }else{
            [self performSegueWithIdentifier:@"ShowSharePageSegue" sender:model.encrypt_id];
        }
    }];    
    return cell;
}

#pragma mark ----------  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = self.myScrollView.contentOffset.x/DEVICE_WIDTH;
    [_topScrollView itemClickByScrollerWithIndex:page];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //侧边栏，暂时隐藏
    /*
    if (scrollView.contentOffset.x < -40 && self.mm_drawerController.openSide == MMDrawerSideNone) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---------  获取用户地理位置信息
- (void) setupLocationManager {
    
    locationManager = [[CLLocationManager alloc] init] ;
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
        
    } else {
        //提示用户无法进行定位操作
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
//            NSLog(@"%@",placemark);
//            //获取城市
//            NSString *city = placemark.locality;
            location_city = [ZTools CutAreaString:placemark.administrativeArea];
            NSLog(@"city ----  %@",location_city);
            [[NSUserDefaults standardUserDefaults] setObject:location_city forKey:GPS_ADDRESS];
        }
    }];
}

-(void)successLoginWithSource:(NSString*)source{
    if ([source isEqualToString:@"personal"]) {
        [self performSegueWithIdentifier:@"showPersonalCenterSegue" sender:nil];
    }
}

#pragma mark -----   SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    FocusImageModel * model = [self.c_array objectAtIndex:index];
    if (model.link.length == 0 || [model.link isKindOfClass:[NSNull class]]) {
        return;
    }
    
    SWebViewController * webViewController = [[SWebViewController alloc] init];
    webViewController.url = model.link;
    [self.navigationController pushViewController:webViewController animated:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSharePageSegue"]) {
        ShareViewController * share = (ShareViewController*)segue.destinationViewController;
        [share setValue:sender forKey:@"task_id"];
    }else if ([segue.identifier isEqualToString:@"ShowTaskDetailSegue"]){
        UIViewController * detail = segue.destinationViewController;
        [detail setValue:sender forKey:@"task_model"];
    }else if ([segue.identifier isEqualToString:@"showLoginSegue"]){
        UINavigationController * navc = (UINavigationController*)segue.destinationViewController;
        LogInViewController * login;
        for (UIViewController * vc in navc.viewControllers) {
            if ([vc isKindOfClass:[LogInViewController class]]) {
                login = (LogInViewController*)vc;
                [login successLogin:^(NSString *source) {
                    if (_contentViews.count>1) {
                        SNRefreshTableView * tableView = _contentViews[0];
                        [tableView showRefreshHeader:YES];
                    }
                    
                    [self successLoginWithSource:sender];
                }];
            }
        }
    }
}


@end
