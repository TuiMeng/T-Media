//
//  MCinemaScheduleViewController.m
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MCinemaScheduleViewController.h"
#import "CinemaSessionsTableViewCell.h"
#import "MovieSelectSeatViewController.h"
#import "MovieSequencesModel.h"
#import "MCinemaDetailViewController.h"
#import "SListTopBarScrollView.h"
#import "MovieDetailViewController.h"

@interface MCinemaScheduleViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    SView   * section_view;
    SView   * footer_view;
    UILabel * emptyLabel;
}


@property(nonatomic,strong)SNRefreshTableView       * myTableView;
@property(nonatomic,strong)NSMutableArray           * dataArray;
@property(nonatomic,strong)SListTopBarScrollView    * topScrollView;
@property(nonatomic,assign)int                      currentPage;

@end

@implementation MCinemaScheduleViewController

-(void)createDataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _cinema_model.cinemaName;
    
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:NO];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [self createSectionHeaderView];
    [self createFooterWithHaveData:YES];
    
    _currentPage = 0;
    [self loadDataWithDayKind:_currentPage];
}


-(void)loadDataWithDayKind:(int)day{
    
    [self createDataArray];
        
    __weak typeof(self)wself = self;
    NSDictionary * dic = @{@"cinemaId":_cinema_model.cinemaId,@"movieId":_movie_model.movieId,@"dayKind":[NSString stringWithFormat:@"%d",day]};
    
    [[ZAPI manager] sendMoviePost:QUERY_MOVIE_PLAY_TIME_URL myParams:dic success:^(id data) {
        if ([wself.dataArray[day] count]) {
            [wself.dataArray[day] removeAllObjects];
        }
        if (data && [data isKindOfClass:[NSArray class]]) {
            for (NSDictionary * obj in data) {
                MovieSequencesModel * model = [[MovieSequencesModel alloc] initWithDictionary:obj];
                [wself.dataArray[day] addObject:model];
            }
        }else if ([data isKindOfClass:[NSDictionary class]]){
            if ([[data objectForKey:@"result"] intValue] != 0) {
                [ZTools showMBProgressWithText:data[@"message"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        [wself createFooterWithHaveData:[wself.dataArray[day] count]];
        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark ---  创建头部视图
-(void)createSectionHeaderView{
    
    if (!section_view) {
        section_view = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 410)];
        
        
        SView * cinemaInfoView = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 55)];
        cinemaInfoView.backgroundColor = [UIColor whiteColor];
        cinemaInfoView.lineColor = DEFAULT_LINE_COLOR;
        cinemaInfoView.isShowBottomLine = YES;
        [section_view addSubview:cinemaInfoView];
        UITapGestureRecognizer * cinemaInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCinemaDetail:)];
        [cinemaInfoView addGestureRecognizer:cinemaInfoTap];
        
        //箭头
        UIImageView * first_arrow_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-23, 20, 8, 15)];
        first_arrow_imageView.image = [UIImage imageNamed:@"cinema_right_arrow_image"];
        [cinemaInfoView addSubview:first_arrow_imageView];
        
        //影院名称
        UILabel * cinema_name_label = [ZTools createLabelWithFrame:CGRectMake(15, 10, DEVICE_WIDTH-80, 30)
                                                              text:_cinema_model.cinemaName
                                                         textColor:RGBCOLOR(31,31,31)
                                                     textAlignment:NSTextAlignmentLeft
                                                              font:15];
        [cinemaInfoView addSubview:cinema_name_label];
        [cinema_name_label sizeToFit];
        
        //影院评分
        UILabel * cinema_score_label = [ZTools createLabelWithFrame:CGRectMake(cinema_name_label.right+5, cinema_name_label.top, 50, cinema_name_label.height)
                                                               text:@"8.7分"
                                                          textColor:RGBCOLOR(255, 132, 1)
                                                      textAlignment:NSTextAlignmentLeft
                                                               font:14];
        [cinemaInfoView addSubview:cinema_score_label];
        [cinema_score_label sizeToFit];
        
        if (cinema_name_label.right >= (first_arrow_imageView.left-cinema_score_label.width-10)) {
            cinema_name_label.width = first_arrow_imageView.left-cinema_score_label.width-25;
            cinema_score_label.right = first_arrow_imageView.left-10;
        }
        
        //地址图标
        UIImageView * location_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cinema_location_image"]];
        location_imageView.center = CGPointMake(25, cinemaInfoView.bottom+25);
        [section_view addSubview:location_imageView];
        //竖线
        UIView * v_line_view = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-60, cinemaInfoView.bottom+7, 0.5, 36)];
        v_line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [section_view addSubview:v_line_view];
        //地址
        UILabel * location_label = [ZTools createLabelWithFrame:CGRectMake(location_imageView.right+5, cinemaInfoView.bottom+7, v_line_view.left-location_imageView.right-5, 36)
                                                           text:_cinema_model.cinemaAddr
                                                      textColor:RGBCOLOR(121,121,121)
                                                  textAlignment:NSTextAlignmentLeft
                                                           font:14];
        location_label.numberOfLines            = 2;
        location_label.userInteractionEnabled   = YES;
        [section_view addSubview:location_label];
        UITapGestureRecognizer * addressTap     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddress:)];
        [location_label addGestureRecognizer:addressTap];
        
        //电话
        UIButton * tel_button = [ZTools createButtonWithFrame:CGRectMake(v_line_view.right, v_line_view.top, DEVICE_WIDTH-v_line_view.right, v_line_view.height)
                                                        title:@""
                                                        image:[UIImage imageNamed:@"cinema_tel_image"]];
        tel_button.backgroundColor = [UIColor whiteColor];
        [tel_button addTarget:self action:@selector(takePhoneNum:) forControlEvents:UIControlEventTouchUpInside];
        [section_view addSubview:tel_button];
        
        //电影信息
        SView * movieInfoView           = [[SView alloc] initWithFrame:CGRectMake(0, location_label.bottom+7, DEVICE_WIDTH, 55)];
        movieInfoView.backgroundColor   = [UIColor whiteColor];
        movieInfoView.lineColor         = DEFAULT_MOVIE_LINE_COLOR;
        movieInfoView.isShowTopLine     = YES;
        movieInfoView.isShowBottomLine  = YES;
        [section_view addSubview:movieInfoView];
        
        UITapGestureRecognizer * movieTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMovieDetail:)];
        [movieInfoView addGestureRecognizer:movieTap];
        
        //箭头
        UIImageView * second_arrow_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-23, (movieInfoView.height-15)/2.0f, 8, 15)];
        second_arrow_imageView.image = [UIImage imageNamed:@"cinema_right_arrow_image"];
        [movieInfoView addSubview:second_arrow_imageView];
        
        //电影名称
        UILabel * movie_name_label = [ZTools createLabelWithFrame:CGRectMake(15, 10, DEVICE_WIDTH-80, 16)
                                                             text:_movie_model.movieName
                                                        textColor:RGBCOLOR(31,31,31)
                                                    textAlignment:NSTextAlignmentLeft
                                                             font:15];
        [movie_name_label sizeToFit];
        [movieInfoView addSubview:movie_name_label];
        //电影评分
        UILabel * movie_score_label = [ZTools createLabelWithFrame:CGRectMake(movie_name_label.right+5, movie_name_label.top, 50, cinema_name_label.height)
                                                              text:@"7.8分"
                                                         textColor:RGBCOLOR(255, 132, 1)
                                                     textAlignment:NSTextAlignmentLeft
                                                              font:14];
        [movie_score_label sizeToFit];
        [movieInfoView addSubview:movie_score_label];
        
        if (movie_name_label.right >= (second_arrow_imageView.left-movie_score_label.width-10)) {
            movie_name_label.width = second_arrow_imageView.left-movie_score_label.width-25;
            movie_score_label.right = second_arrow_imageView.left-10;
        }
        
        //时长
        UILabel * movie_time_label = [ZTools createLabelWithFrame:CGRectMake(15, movie_name_label.bottom+5, second_arrow_imageView.left-40, 18)
                                                             text:[NSString stringWithFormat:@"片长：%@分钟",_movie_model.duration]
                                                        textColor:RGBCOLOR(162, 162, 162)
                                                    textAlignment:NSTextAlignmentLeft
                                                             font:12];
        [movieInfoView addSubview:movie_time_label];
        
        UIView * separator_view         = [[UIView alloc] initWithFrame:CGRectMake(0, movieInfoView.bottom, DEVICE_WIDTH, 15)];
        separator_view.backgroundColor  = RGBCOLOR(237, 237, 237);
        [section_view addSubview:separator_view];
        
        //温馨提示
        SView * reminderView            = [[SView alloc] initWithFrame:CGRectMake(0, separator_view.bottom, DEVICE_WIDTH, 35)];
        reminderView.backgroundColor    = RGBCOLOR(255, 241, 209);
        reminderView.lineColor          = DEFAULT_MOVIE_LINE_COLOR;
        reminderView.isShowTopLine      = YES;
        reminderView.isShowBottomLine   = YES;
        [section_view addSubview:reminderView];
        
        UILabel * reminderLabel         = [ZTools createLabelWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, reminderView.height)
                                                                  text:@"温馨提示：电影开场前15分钟关闭在线售票"
                                                             textColor:DEFAULT_ORANGE_TEXT_COLOR
                                                         textAlignment:NSTextAlignmentCenter
                                                                  font:14];
        [reminderLabel sizeToFit];
        reminderLabel.center            = CGPointMake(DEVICE_WIDTH/2.0f, reminderView.height/2.0f);
        [reminderView addSubview:reminderLabel];
        
        
        self.topScrollView                          = [[SListTopBarScrollView alloc] initWithFrame:CGRectMake(0,reminderView.bottom,DEVICE_WIDTH,45)];
        self.topScrollView.titleNormalColor         = [UIColor blackColor];
        self.topScrollView.btnWidth                 = 120;
        self.topScrollView.lineWidth                = 100;
        self.topScrollView.titleSelectedColor       = DEFAULT_RED_TEXT_COLOR;
        self.topScrollView.titleFont                = [ZTools returnaFontWith:13];
        self.topScrollView.visibleItemList          = [MovieTools returnThreeDaysArray];
        self.topScrollView.backgroundColor          = [UIColor whiteColor];
        __weak typeof(self)wself                    = self;
        self.topScrollView.listBarItemClickBlock    = ^(NSString *itemName , NSInteger itemIndex){
            wself.currentPage = (int)itemIndex;
            if ([wself.dataArray[wself.currentPage] count]) {
                [wself createFooterWithHaveData:YES];
                [wself.myTableView finishReloadigData];
            }else{
                [wself loadDataWithDayKind:wself.currentPage];
            }
        };
        [section_view addSubview:self.topScrollView];

        
        section_view.height                         = self.topScrollView.bottom+0.5;
        section_view.lineColor                      = DEFAULT_LINE_COLOR;
        section_view.isShowBottomLine               = YES;
        _myTableView.tableHeaderView                = section_view;
    }
}

#pragma mark ----  创建已映完底部视图
-(void)createFooterWithHaveData:(BOOL)haveData{
    if (!footer_view) {
        footer_view                 = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
        footer_view.clipsToBounds   = YES;
        footer_view.backgroundColor = DEFAULT_MOVIE_LINE_COLOR;
        
        emptyLabel = [ZTools createLabelWithFrame:footer_view.bounds
                                             text:@"今天场次已映完"
                                        textColor:DEFAULT_GRAY_TEXT_COLOR
                                    textAlignment:NSTextAlignmentCenter
                                             font:15];
        [footer_view addSubview:emptyLabel];
    }
    
    footer_view.height              = haveData?0:50;
    _myTableView.tableFooterView    = footer_view;
}

#pragma mark --------UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[_currentPage] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier        = @"identifier";
    CinemaSessionsTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell                = [[CinemaSessionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MovieSequencesModel * model         = _dataArray[_currentPage][indexPath.row];
    [cell setInfomationWithMovieSequencesModel:model];
    cell.end_time_label.text            =[NSString stringWithFormat:@"%@散场",[MovieTools getEndTimeWithStartTime:model.seqTime WithDur:_movie_model.duration.intValue]];
    
    __weak typeof(self)wself = self;
    [cell selectSeatBlock:^(id obj) {
        MovieSelectSeatViewController * viewController  = [[MovieSelectSeatViewController alloc] init];
        viewController.cinema_model                     = wself.cinema_model;
        viewController.movie_model                      = wself.movie_model;
        viewController.sequenceModel                    = model;
        [wself.navigationController pushViewController:viewController animated:YES];
    }];
    
    return cell;
}

-(void)loadNewData{
    [self loadDataWithDayKind:_currentPage];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark ------   显示影院详情
-(void)showCinemaDetail:(UITapGestureRecognizer *)sender{
    
    MCinemaDetailViewController * viewController    = [[MCinemaDetailViewController alloc] init];
    viewController.cinema_model                     = _cinema_model;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -----  显示地理位置
-(void)showAddress:(UITapGestureRecognizer *)sender{
    
}

#pragma mark -----   拨打电话
-(void)takePhoneNum:(UIButton *)button{
    
}

#pragma mark -------  查看电影信息
-(void)showMovieDetail:(UITapGestureRecognizer *)sender{
    MovieDetailViewController * detailVC = [[MovieDetailViewController alloc] init];
    detailVC.movie_list_model = _movie_model;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
