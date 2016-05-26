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
#import "SWebViewController.h"
#import "WXUtil.h"
#import "UIAlertView+Blocks.h"

#define ROOT_TASK_ID @"1"
#define ROOT_GAME_ID @"4"
#define ROOT_MOVIE_ID @"2"

@interface RootViewController ()<SNRefreshDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    BOOL                isShowCycleView;
    /**
     *  选择地区按钮
     */
    UIButton            * left_button;
    /**
     *  当前显示的第几页
     */
    int                 currentPage;
    
    AMapLocationManager * locationManager;
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
    
    //当前选中地区
    NSString            * currentArea;
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
    currentArea = [ZTools getSelectedCity];
    if (!left_button) {
        UIImage * image = [UIImage imageNamed:@"seller_bottom_arrow_image"];
        left_button = [ZTools createButtonWithFrame:CGRectMake(0, 0, 70, 44) title:currentArea image:image];
        left_button.adjustsImageWhenHighlighted = NO;
        left_button.clipsToBounds = YES;
        [left_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        left_button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [left_button addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_button];
    }
    
    [left_button setTitle:currentArea forState:UIControlStateNormal];
    CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:12] WithString:currentArea WithWidth:left_button.width];
    
    [left_button setImageEdgeInsets:UIEdgeInsetsMake(0, size.width+2, 0, 0)];
    [left_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0,left_button.width - size.width-1)];

   
}

-(void)leftButtonClicked:(UIButton *)button{
    MovieCityViewController * viewController = [[MovieCityViewController alloc] init];
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.current_city = currentArea;
    [self presentViewController:navc animated:YES completion:nil];
    
    __WeakSelf__ wself = self;
    [viewController selectedCityWithCityBlock:^(MovieCityModel *model) {
        [ZTools setSelectedCity:model.cityName cityId:model.cityId];
        currentArea = model.cityName;
        [wself createLeftItem];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
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
//        [self performSegueWithIdentifier:@"showLoginSegue" sender:@"personal"];
        __weak typeof(self)wself = self;
        [[LogInView sharedInstance] loginShowWithSuccess:^{
            [wself performSegueWithIdentifier:@"showPersonalCenterSegue" sender:nil];
        }];
        
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
//获取已结束任务数据
-(void)loadOffLineTaskListData{
    
    __weak typeof(self)wself        = self;
    RootTopTitleModel*model         = _top_array[currentPage];
    SNRefreshTableView * tableView  = _contentViews[currentPage];
    
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
#pragma mark ------  下载任务列表文件
-(void)loadRootTaskListFile{
    int page = currentPage;
    SNRefreshTableView * tableView = _contentViews[page];
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Test_version/include/index_lista.txt?%@",WEBSITE,[ZTools timechangeToDateline]]]];
    
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] init];
    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/task.txt"];
    NSString *copy_path = [NSHomeDirectory() stringByAppendingString:@"/Documents/task_copy.txt"];

    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response)
                                       {
                                           
                                           // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
                                           NSURL *fileURL = [NSURL fileURLWithPath:copy_path];
                                           
                                           return fileURL;
                                       }completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                           if (error) {
                                               [ZTools showMBProgressWithText:@"请求超时..." WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
                                               [tableView finishReloadigData];
                                           }else{
                                               NSLog(@"下载成功");
                                               NSData *data = [[NSMutableData alloc] initWithContentsOfFile:copy_path];
                                               id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                               NSLog(@"json:%@",json);
                                               if (json && [json isKindOfClass:[NSArray class]]) {
                                                   [self.data_array[page] removeAllObjects];
                                                   tableView.isHaveMoreData = YES;
                                                   [self handleTaskDataWithDictionary:json WithTableView:tableView WithPage:page];
                                                   
                                                   //把数据写入到task.txt
                                                   [json writeToFile:savedPath atomically:NO];
                                                   
                                                   //删除下载的文件，避免下次下载不替换原文件
                                                   NSFileManager * fileManager = [NSFileManager defaultManager];
                                                   if ([fileManager fileExistsAtPath:copy_path]) {
                                                       [fileManager removeItemAtPath:copy_path error:nil];
                                                   }
                                               }else{
                                                   [ZTools showMBProgressWithText:@"加载失败，请重试" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
                                               }
                                               [tableView finishReloadigData];

                                           }
                                       }];
    
    [task resume];

}

-(void)loadFocusData{
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&type=%@",GIFT_FOCUS_IMAGES_URL,@"root"] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [_c_array           removeAllObjects];
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
        _top_title_array    = [NSMutableArray array];
        _top_array          = [NSMutableArray array];
    }
    [_top_title_array removeAllObjects];
    [_top_array removeAllObjects];
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendGet:ROOT_TITLES_URL success:^(id data) {
        if ( data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:ERROR_CODE];
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

    if (!_c_array) {
        _c_array            = [NSMutableArray array];
        _focus_image_array  = [NSMutableArray array];
        _focus_title_array  = [NSMutableArray array];
    }
    for (NSDictionary * dic in array) {
        
        RootTopTitleModel * model = [[RootTopTitleModel alloc] initWithDictionary:dic];
        [self.top_array addObject:model];
        [self.top_title_array addObject:model.column_name];
        
        [_c_array           addObject:model.is_show.intValue?[NSMutableArray array]:@""];
        [_focus_image_array addObject:model.is_show.intValue?[NSMutableArray array]:@""];
        [_focus_title_array addObject:model.is_show.intValue?[NSMutableArray array]:@""];
    }
    [self createMainViews];
    [self createTopTitleView];
}

-(void)createTopTitleView{
    
    _topScrollView = [[SListTopBarScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,45)];
    __weak typeof(self)wself = self;
    _topScrollView.scrollsToTop = NO;
    float titleWidth = DEVICE_WIDTH/4.0f-10;
    if (_top_title_array.count*titleWidth < DEVICE_WIDTH) {
        titleWidth = DEVICE_WIDTH/_top_title_array.count;
    }
    _topScrollView.btnWidth                 = titleWidth;
    _topScrollView.lineWidth                = titleWidth-20;
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
             RootMovieView * movieView = (RootMovieView *)tableView;
             //判断如果是第一次则加载数据
             if (movieView.data_array.count == 0) {
                 [(RootMovieView*)tableView loadMoiveData];
             }
         }else if ([tableView isKindOfClass:[UIWebView class]]){
             UIWebView * webView = (UIWebView *)tableView;
             [MobClick event:@"RootGame"];
             if (!webView.request.URL) {
                 [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:GAME_SITE]]];
             }
         }else{
             [(SNRefreshTableView*)pre_tableView setScrollsToTop:NO];
             
             [(SNRefreshTableView*)tableView setScrollsToTop:YES];
             if ([wself.data_array[currentPage] count] == 0) {
                 ///加载数据
                 [tableView showRefreshHeader:YES];
             }
         }
     }];
}
#pragma mark -----  创建所有tableview
-(void)createMainViews{
    for (int i = 0; i < self.top_array.count; i++) {
        RootTopTitleModel * model = _top_array[i];
        [_data_array addObject:[NSMutableArray array]];
        if ([model.id isEqualToString:ROOT_MOVIE_ID])//电影频道
        {
            RootMovieView * movie_view = [[RootMovieView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*i, 0, DEVICE_WIDTH, self.myScrollView.height)];
            movie_view.viewController = self;
            [_myScrollView addSubview:movie_view];
            [_contentViews addObject:movie_view];
            
        }else if ([model.id isEqualToString:ROOT_GAME_ID]){
            
            UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*i,0,DEVICE_WIDTH,self.myScrollView.height)];
            webView.scalesPageToFit = YES;
            [_myScrollView addSubview:webView];
            [_contentViews addObject:webView];
        }else if([model.id isEqualToString:ROOT_TASK_ID])
        {
            SNRefreshTableView * tableView  = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*i,0,DEVICE_WIDTH,self.myScrollView.height) showLoadMore:YES];
            tableView.separatorStyle        = UITableViewCellSeparatorStyleNone;
            tableView.refreshDelegate       = self;
            tableView.dataSource            = self;
            tableView.isHaveMoreData        = NO;
            tableView.tag                   = 1000 + i;
            tableView.backgroundColor       = RGBCOLOR(237, 237, 237);
            tableView.scrollsToTop          = NO;
            if (i==0) {
                tableView.scrollsToTop      = YES;
            }
            
            [_myScrollView addSubview:tableView];
            [_contentViews addObject:tableView];
        }
        
    }
    
    [self loadTaskCacheFile];
    
    _myScrollView.contentSize = CGSizeMake(DEVICE_WIDTH*_top_array.count, 0);
}

-(void)setCycleView{
    
    _cycle_scrollView                   = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,40,DEVICE_WIDTH,[ZTools autoHeightWith:180]) imageURLStringsGroup:_focus_image_array];
    _cycle_scrollView.titlesGroup       = _focus_title_array;
    _cycle_scrollView.delegate          = self;
    _cycle_scrollView.pageControlStyle  = SDCycleScrollViewPageContolStyleClassic;
    _cycle_scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycle_scrollView.autoScrollTimeInterval = 5.f;
    
    if (currentPage == 0) {
        UITableView * tableView     = (UITableView*)[_myScrollView viewWithTag:1000];
        tableView.tableHeaderView   = _cycle_scrollView;
    }
}
#pragma mark ------------------   Refresh delegate methods
- (void)loadNewData{
    RootTopTitleModel * model = _top_array[currentPage];
    if ([model.id isEqualToString:ROOT_TASK_ID]) {

        [self loadFocusData];
        [self loadRootTaskListFile];
    }
}
- (void)loadMoreData{
    RootTopTitleModel * model = _top_array[currentPage];
    if ([_data_array[currentPage] count] != 0 && [model.id isEqualToString:ROOT_TASK_ID]) {
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
            [[LogInView sharedInstance] loginShowWithSuccess:nil];
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
    
    __weak typeof(self)wself = self;
    //高德地图
    [AMapLocationServices sharedServices].apiKey = AMAP_KEY;
    
    
    locationManager = [[AMapLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    locationManager.locationTimeout = 3;
    locationManager.reGeocodeTimeout = 3;
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                
            }
        }
        
//        locationLat = location.coordinate.latitude;
//        locationLng = location.coordinate.longitude;
        if (regeocode)
        {
            NSLog(@"regeoco.city ----  %@",regeocode.formattedAddress);
            [wself handleLocationManagerDataWithCity:regeocode.formattedAddress];
            
        }
    }];
}

#pragma mark ----  处理定位信息
-(void)handleLocationManagerDataWithCity:(NSString *)city{
    if (city.length == 0) {
        return;
    }
    location_city = [ZTools CutAreaString:city];
    
    NSRange range = [city rangeOfString:@"市"];
    if (range.length) {
        city = [city substringToIndex:range.location];
    }
    
    if (![currentArea rangeOfString:city].length) {
        __WeakSelf__ wself = self;
        UIAlertView * alertView = [UIAlertView showWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"系统定位您在%@，是否切换到当前城市",city] cancelButtonTitle:@"取消" otherButtonTitles:@[@"切换"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                MBProgressHUD * hud = [ZTools showMBProgressWithText:@"切换中" WihtType:MBProgressHUDModeIndeterminate addToView:wself.view isAutoHidden:NO];
                [[MovieNetWork sharedManager] checkCityIdWitCityName:city success:^(id data) {
                    [hud hide:YES];
                    [wself createLeftItem];
                } failure:^(NSString *error) {
                    [hud hide:YES];
                    [ZTools showMBProgressWithText:error WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                }];
            }
        }];
        [alertView show];
    }
    [[NSUserDefaults standardUserDefaults] setObject:location_city forKey:GPS_ADDRESS];
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
                    if (_contentViews.count>1 && currentPage == 0) {
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
