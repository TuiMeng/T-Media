//
//  RootMovieView.m
//  推盟
//
//  Created by joinus on 16/3/2.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "RootMovieView.h"
#import "RootMovieTableViewCell.h"
#import "MovieListModel.h"
#import "MovieDetailViewController.h"
#import "MovieCityViewController.h"
#import "MNearByCinemasViewController.h"
#import "MovieTopicListViewController.h"
#import "FocusImageModel.h"

@interface RootMovieView ()<UISearchBarDelegate,SDCycleScrollViewDelegate>{
    UIButton * area_button;
    float _lastPosition;
}

@property(nonatomic,strong)NSString         * current_city;
@property(nonatomic,strong)NSMutableArray   * rowHeightArray;
@property(nonatomic,strong)SDCycleScrollView * cycle_scrollView;

@property(nonatomic,strong)NSMutableDictionary  * cycleData;

@end

@implementation RootMovieView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _data_array         = [NSMutableArray array];
        _rowHeightArray     = [NSMutableArray array];
      //  [self setTopView];
        [self setTableView];
//        [self loadMoiveData];
        [self loadFocusData];
    }
    return self;
}
#pragma mark -----  创建视图
-(void)setTopView{
    _top_view                       = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    _top_view.backgroundColor       = [UIColor whiteColor];
    _top_view.lineColor             = DEFAULT_MOVIE_LINE_COLOR;
    _top_view.isShowTopLine         = YES;
    _top_view.isShowBottomLine      = YES;
    [self addSubview:_top_view];
    
    UISearchBar * search_bar        = [[UISearchBar alloc] initWithFrame:CGRectMake(50, (_top_view.height-25)/2.0f, DEVICE_WIDTH-100,25)];
    search_bar.delegate             = self;
    search_bar.backgroundColor      =[UIColor whiteColor];
    search_bar.tintColor            = RED_BACKGROUND_COLOR;
    search_bar.barTintColor         = [UIColor whiteColor];
    search_bar.placeholder          = @"搜索";
    search_bar.backgroundImage      = [UIImage imageNamed:@"searchbar_background_image"];
    search_bar.layer.borderColor    = RED_BACKGROUND_COLOR.CGColor;
    search_bar.layer.borderWidth    = 0.5;
    search_bar.layer.cornerRadius   = 8;
    
    UITextField *searchField        = [search_bar valueForKey:@"_searchField"];
    searchField.textColor           = RED_BACKGROUND_COLOR;
    searchField.font                = [ZTools returnaFontWith:12];
    [_top_view addSubview:search_bar];
    
    
    area_button                     = [ZTools createButtonWithFrame:CGRectMake(10, (_top_view.height-30)/2.0f, 50, 30) title:[ZTools getSelectedCity] image:nil];
    area_button.backgroundColor     = [UIColor whiteColor];
    area_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [area_button setTitle:[ZTools getSelectedCity] forState:UIControlStateNormal];
    area_button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [area_button layoutIfNeeded];
    [area_button setImage:[UIImage imageNamed:@"root_area_arrow_down_image"] forState:UIControlStateNormal];
    [area_button setTitleColor:RED_BACKGROUND_COLOR forState:UIControlStateNormal];
    area_button.titleLabel.font     = [ZTools returnaFontWith:12];
    [area_button addTarget:self action:@selector(areaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self updateButtonContentWithButton:area_button WithText:@"北京"];
   // [_top_view addSubview:area_button];
    
    
    /*
    UIButton * screen_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-40, 5, 30, 20) title:@"筛选" image:nil];
    [screen_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    screen_button.titleLabel.font = [ZTools returnaFontWith:12];
    screen_button.layer.borderColor = RED_BACKGROUND_COLOR.CGColor;
    screen_button.layer.borderWidth = 0.5;
    screen_button.layer.cornerRadius = 5;
    [screen_button addTarget:self action:@selector(screenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [top_view addSubview:screen_button];
    */
}
#pragma mark -----  创建轮播图
-(void)setCycleView{
    
    _cycle_scrollView                   = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,DEVICE_WIDTH,[ZTools autoHeightWith:80]) imageURLStringsGroup:_cycleData[@"image"]];
//    _cycle_scrollView.titlesGroup       = _cycleData[@"title"];
    _cycle_scrollView.delegate          = self;
    _cycle_scrollView.pageControlStyle  = SDCycleScrollViewPageContolStyleNone;
    _cycle_scrollView.autoScrollTimeInterval = 5.f;
    _myTableView.tableHeaderView   = _cycle_scrollView;
}


-(void)setTableView{
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, _cycle_scrollView.bottom, DEVICE_WIDTH, self.height-_cycle_scrollView.height) showLoadMore:YES];
    _myTableView.backgroundColor    = RGBCOLOR(237, 237, 237);
    _myTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [_myTableView removeFooterView];
    [self addSubview:_myTableView];
}

-(void)setNavigationViewShow:(RootMovieShowNavigationViewBlock)block{
    RootUpDownBlock = block;
}
#pragma mark -------  网络请求
//获取轮播图数据
-(void)loadFocusData{
    
    if (!_cycleData) {
        _cycleData = [NSMutableDictionary dictionary];
    }
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&type=%@",GIFT_FOCUS_IMAGES_URL,@"film"] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSMutableArray * modelArray = [NSMutableArray array];
            NSMutableArray * titleArray = [NSMutableArray array];
            NSMutableArray * imageArray = [NSMutableArray array];
            NSArray * array = [data objectForKey:@"Focus_img"];
            for (NSDictionary * dic in array) {
                
                FocusImageModel * model = [[FocusImageModel alloc] initWithDictionary:dic];
                [modelArray addObject:model];
                [imageArray addObject:model.focus_img];
                [titleArray addObject:model.title];
            }
            
            [_cycleData setObject:modelArray forKey:@"model"];
            [_cycleData setObject:imageArray forKey:@"image"];
            [_cycleData setObject:titleArray forKey:@"title"];
            modelArray = nil;
            imageArray = nil;
            titleArray = nil;
            
            
            [wself setCycleView];
        }
        
    } failure:^(NSError *error) {
        
    }];
}



//获取电影数据
-(void)loadMoiveData{
    __weak typeof(self)wself = self;
    NSDictionary * dic = @{@"cityId":[ZTools getSelectedCityId],@"kind":@"1",@"page":@(_myTableView.pageNum)};
    NSLog(@"------  %@",[NSString stringWithFormat:@"%@qrMovies?",BASE_MOVIE_URL]);
    [[ZAPI manager] sendMoviePost:[NSString stringWithFormat:@"%@qrMovies?",BASE_MOVIE_URL] myParams:dic success:^(id data) {
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if (data && [data isKindOfClass:[NSArray class]]) {
            
            [wself.data_array removeAllObjects];
            
            if ([data count] > 0) {
                for (NSDictionary * item in data) {
                    MovieListModel * model  = [[MovieListModel alloc] initWithDictionary:item];
                    
                    float rowHeitht         = 100+(model.reward.length?30:0) + (model.topic.length?30:0);
                    
                    [dic                    setObject:model forKey:model.movieId];
                    [wself.data_array       addObject:model];
                    [wself.rowHeightArray   addObject:@(rowHeitht)];
                }
            }
        }
        
//        [wself sortDataWithArray:dic];
        
        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [wself.myTableView finishReloadigData];
    }];
}

-(void)sortDataWithArray:(NSMutableDictionary *)dic{
    NSArray             * keys = dic.allKeys;
    NSMutableArray      * tempArray = [NSMutableArray array];
    for (NSString * string in keys) {
        [tempArray addObject:[NSNumber numberWithLongLong:[string longLongValue]]];
    }
    
    NSArray * tempArray1 = [NSArray arrayWithArray:tempArray];
    tempArray1 = [tempArray1 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    for (NSNumber * obj in tempArray1) {
        NSLog(@"id -=-=-=-=   %@",obj);
        MovieListModel * model = (MovieListModel*)[dic objectForKey:[NSString stringWithFormat:@"%@",obj]];
        [_data_array addObject:model];
        float rowHeitht         = 110+(model.reward.length?30:0) + (model.topic.length?30:0);
        [self.rowHeightArray   addObject:@(rowHeitht)];
    }
    
}

#pragma mark ------  TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    RootMovieTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RootMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = RGBCOLOR(237, 237, 237);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MovieListModel * model = [_data_array objectAtIndex:indexPath.row];
    
    [cell setInfomationWithMovieListModel:model];
    
    __weak typeof(self)wself = self;
    [cell setBuyTicketClickedBlock:^(NSString *obj) {
        [wself showNavigationBar];
        MNearByCinemasViewController * cinema_vc = [[MNearByCinemasViewController alloc] init];
        cinema_vc.movieModel = model;
        [wself.viewController.navigationController pushViewController:cinema_vc animated:YES];
    }];
    
    [cell setTopicOrRewardwTap:^(int type) {
        [wself showNavigationBar];
        if (type == 1) {
            
        }else if (type == 2){
            
            MovieTopicListViewController * viewController = [[MovieTopicListViewController alloc] init];
            viewController.movieListModel = model;
            [wself.viewController.navigationController pushViewController:viewController animated:YES];
        }
    }];
    
    return cell;
}

- (void)loadNewData{
    [self loadMoiveData];
}
- (void)loadMoreData{
    [self loadMoiveData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showNavigationBar];
    MovieListModel * model = [_data_array objectAtIndex:indexPath.row];
    MovieDetailViewController * detailVC = [[MovieDetailViewController alloc] init];
    detailVC.movie_id = model.movieId;
    detailVC.movie_list_model = model;
    [_viewController.navigationController pushViewController:detailVC animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    
    return [_rowHeightArray[indexPath.row] floatValue];
}


-(void)refreshScrollViewDidScroll:(UIScrollView *)scrollView{
    /*
    float currentPostion = scrollView.contentOffset.y;
    if ((currentPostion > _lastPosition && currentPostion >= 200))
    {
        RootUpDownBlock(NO);
        
    }else if (_lastPosition > currentPostion && scrollView.contentSize.height-(DEVICE_HEIGHT-64) > currentPostion && currentPostion <= 200)
    {
        RootUpDownBlock(YES);
    }
    
    _lastPosition = currentPostion;
     */
}


#pragma mark ----- UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return NO;
}

-(void)areaButtonClicked:(UIButton*)button{
    
    MovieCityViewController * viewController = [[MovieCityViewController alloc] init];
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.current_city = _current_city;
    [_viewController presentViewController:navc animated:YES completion:nil];
    
    __weak typeof(self)wself = self;
    [viewController selectedCityWithCityBlock:^(MovieCityModel *model) {
        [button setTitle:model.cityName forState:UIControlStateNormal];
        wself.current_city = model.cityName;
        [wself updateButtonContentWithButton:button WithText:model.cityName];
    }];
}
#pragma mark -------   轮播图代理回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    FocusImageModel * model = [self.cycleData[@"model"] objectAtIndex:index];
    if (model.link.length == 0 || [model.link isKindOfClass:[NSNull class]]) {
        return;
    }
    
    SWebViewController * webViewController = [[SWebViewController alloc] init];
    webViewController.url = model.link;
    [_viewController.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark ---  筛选
-(void)screenButtonClicked:(UIButton*)button{
    
}

-(void)setViewController:(UIViewController *)viewController{
    _viewController = viewController;
}

-(void)updateButtonContentWithButton:(UIButton*)btn WithText:(NSString*)text{
    
    CGSize text_size = [ZTools stringHeightWithFont:btn.titleLabel.font WithString:text WithWidth:MAXFLOAT];
    float text_widht = text_size.width;
    UIImage * image = btn.imageView.image;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, text_widht+3, 0,-image.size.width)];
}

-(void)showNavigationBar{
    [self.viewController.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
