//
//  MovieDetailViewController.m
//  推盟
//
//  Created by joinus on 16/3/3.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieComentTableViewCell.h"
#import "MovieCommentScoreViewController.h"
#import "TopicTableViewCell.h"
#import "MovieCommentsModel.h"
#import "MovieTopicModel.h"
#import "MovieCommentsListViewController.h"
#import "MovieTopicListViewController.h"
#import "MPublishCommentViewController.h"
#import "MPublishTopicViewController.h"
#import "MNearByCinemasViewController.h"
#import "MovieTopicDetailViewController.h"
#import "MovieModel.h"

@interface MovieDetailViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    UIView * section_view;
    UIImageView * header_imageView;
    UILabel * movie_engish_name_label;
    DJWStarRatingView * starRatingView;
    UILabel * score_label;
    UILabel * score_people_label;
    UILabel * type_label;
    UILabel * play_area_time_label;
    UILabel * release_date_label;
    UIButton * show_detail_button;
    UIView * introduction_background_view;
    SLabel * introduction_label;
    UIButton * buy_ticket_button;
    UIView * want_share_view;
    UIButton * want_share_button;
}



@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)NSArray              * dataArray;
//总评论数
@property(nonatomic,assign)int                  totalCount;
@property(nonatomic,strong)MovieModel           * movieModel;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.numberOfLines = 0;
    self.title_label.text = _movie_list_model.movieName;
//    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"movie_share_image"];
    
    _dataArray = @[[NSMutableArray array],[NSMutableArray array]];
    
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:NO];
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [self.view addSubview:_myTableView];
    [_myTableView removeFooterView];
    _myTableView.tableFooterView    = [[UIView alloc]initWithFrame:CGRectZero];
    _myTableView.contentInset       = UIEdgeInsetsMake(50, 0, 0, 0);
    _myTableView.pageNum            = 0;
    
    [self loadMovieData];
    [self loadCommentsData];
    [self createSectionView];
        
}

#pragma mark -------   分享
-(void)rightButtonTap:(UIButton *)sender{
    
    [MobClick event:@"MovieShare"];
    
    SShareView * shareView = [[SShareView alloc] initWithTitles:@[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE,SHARE_TENTCENT_QQ,SHARE_SINA_WEIBO,SHARE_QZONE,SHARE_DOUBAN]
                                                          title:[NSString stringWithFormat:@"《%@》 %@分",_movie_list_model.movieName,_movie_list_model.movieScore]
                                                        content:[NSString stringWithFormat:@"《%@》%@上映，%@跟您一起聊聊电影中的那些事",_movie_list_model.movieName,_movie_list_model.releaseDate,APP_NAME]
                                                            Url:WEBSITEH5
                                                          image:[UIImage imageNamed:@"Icon"]
                                                       location:nil
                                                    urlResource:nil
                                            presentedController:self];
    [shareView showInView:self.navigationController.view];
    
    
    [shareView shareButtonClicked:^(NSString *snsName, NSString *shareType) {
        [shareView shareWithSNS:snsName WithShareType:shareType];
    }];
    
    __weak typeof(shareView)wShareView = shareView;
    __weak typeof(self)wself = self;
    
    [shareView setShareSuccess:^(NSString *type) {
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        
    } failed:^{
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark ----  网络请求
-(void)loadMovieData{
    NSLog(@"电影详情-----%@",GET_MOVIEW_DETAIL_URL(_movie_list_model.movieId));
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:GET_MOVIEW_DETAIL_URL(_movie_list_model.movieId) myParams:nil success:^(id data) {
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            wself.movieModel = [[MovieModel alloc] initWithDictionary:data];
        }
        
        [wself setSectionInfo];
        [wself.myTableView finishReloadigData];
        
    } failure:^(NSError *error) {
        [wself.myTableView finishReloadigData];
    }];
}
-(void)loadCommentsData{
    
    __WeakSelf__ wself = self;
    
    NSDictionary * dic =@{@"movieId":_movie_list_model.movieId,
                          @"pageId":@(_myTableView.pageNum),
                          @"pageSize":@"10"};
    
    [[ZAPI manager] sendPost:GET_MOVIE_COMMENTS_URL myParams:dic success:^(id data) {
        
        if (wself.myTableView.pageNum == 0) {
            [wself.dataArray[0] removeAllObjects];
        }
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[MOVIE_ERROR_CODE] intValue] == 0) {
                wself.totalCount = [data[@"count"] intValue];
                NSArray * array = data[@"datas"];
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    
                    int count = wself.totalCount>3?3:wself.totalCount;
                    
                    for (int i = 0; i < count; i++) {
                        NSDictionary * item = array[i];
                        MovieCommentsModel * model = [[MovieCommentsModel alloc] initWithDictionary:item];
                        [wself.dataArray[0] addObject:model];
                    }
                }
            }else{
                [ZTools showMBProgressWithText:data[MOVIE_ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        
        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [wself.myTableView finishReloadigData];
    }];
}


#pragma mark ------  创建头视图
-(void)createSectionView{
    
    if (!section_view) {
        section_view                                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 400)];
        
        UIImageView * movie_info_background_imageView           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 180)];
        movie_info_background_imageView.image                   = [UIImage imageNamed:@"movie_detail_section_background_image"];
        movie_info_background_imageView.userInteractionEnabled  = YES;
        [section_view addSubview:movie_info_background_imageView];
        //头图
        header_imageView                                        = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 227/2.0f, 305/2.0f)];
        [header_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_MOVIE_IMAGE_URL,_movie_list_model.movieImage.length?_movie_list_model.movieImage:_movie_list_model.moviePick]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_SMALL_IMAGE]];
        [movie_info_background_imageView addSubview:header_imageView];
        //电影名称
        UILabel * movie_name_label                              = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, 15, DEVICE_WIDTH-(header_imageView.right+10)-10, 18)
                                                                                          text:_movie_list_model.movieName
                                                                                     textColor:[UIColor whiteColor]
                                                                                 textAlignment:NSTextAlignmentLeft
                                                                                          font:16];
        [movie_info_background_imageView addSubview:movie_name_label];
        //电影英文名称
        movie_engish_name_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, movie_name_label.bottom+2, DEVICE_WIDTH-(header_imageView.right+10)-10, 15)
                                                          text:@""
                                                     textColor:[UIColor whiteColor]
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:10];
        [movie_info_background_imageView addSubview:movie_engish_name_label];
        //星星
        starRatingView = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(18, 18)
                                                       numberOfStars:5
                                                              rating:4.5
                                                           fillColor:STAR_FILL_COLOR
                                                       unfilledColor:STAR_UNFILL_COLOR
                                                         strokeColor:[UIColor clearColor]];
        starRatingView.padding  = 1;
        starRatingView.top      = movie_engish_name_label.bottom+5;
        starRatingView.left     = header_imageView.right+10;
        [movie_info_background_imageView addSubview:starRatingView];
        //评分
        score_label = [ZTools createLabelWithFrame:CGRectMake(starRatingView.right+10, movie_engish_name_label.bottom+5, DEVICE_WIDTH-starRatingView.right-20, 15)
                                              text:@""
                                         textColor:RGBCOLOR(239, 165, 85)
                                     textAlignment:NSTextAlignmentLeft
                                              font:15];
        [movie_info_background_imageView addSubview:score_label];
        /*
        //评论人数
        score_people_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, score_label.bottom+5, DEVICE_WIDTH-header_imageView.right-20, 16)
                                                     text:@"(0人评分)"
                                                textColor:RGBCOLOR(239, 165, 85)
                                            textAlignment:NSTextAlignmentLeft
                                                     font:15];
        [movie_info_background_imageView addSubview:score_people_label];
         */
        //类型
        type_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, score_label.bottom+15, DEVICE_WIDTH-header_imageView.right-20, 16)
                                             text:@""
                                        textColor:[UIColor whiteColor]
                                    textAlignment:NSTextAlignmentLeft
                                             font:12];
        [movie_info_background_imageView addSubview:type_label];
        
        //上映地区+时长
        play_area_time_label = [ZTools createLabelWithFrame:CGRectMake(type_label.left, type_label.bottom+5, type_label.width, 16)
                                                       text:@""
                                                  textColor:[UIColor whiteColor]
                                              textAlignment:NSTextAlignmentLeft
                                                       font:12];
        [movie_info_background_imageView addSubview:play_area_time_label];
        
        //上映日期
        release_date_label = [ZTools createLabelWithFrame:CGRectMake(type_label.left, play_area_time_label.bottom+5, type_label.width, 16)
                                                     text:@""
                                                textColor:[UIColor whiteColor]
                                            textAlignment:NSTextAlignmentLeft
                                                     font:12];
        [movie_info_background_imageView addSubview:release_date_label];
        
        /*想看+评分按钮
        float image_width = (DEVICE_WIDTH-30-15)/2.0f;
        NSArray * image_array = @[@"想看",@"评分",@"",@""];
        
        for (int i = 0; i < 2; i++) {
            UIButton * button = [ZTools createButtonWithFrame:CGRectMake(15+(image_width+15)*i, movie_info_background_imageView.height-45, image_width, 66/2.0f)
                                                        title:image_array[i]
                                                        image:nil];
            button.layer.borderColor    = RGBCOLOR(198, 208, 208).CGColor;
            button.tag                  = 100 + i;
            button.layer.borderWidth    = 0.5;
            button.backgroundColor      = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
            button.titleLabel.font      = [ZTools returnaFontWith:13];
            [button addTarget:self action:@selector(wantAndCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [movie_info_background_imageView addSubview:button];
        }
        
        want_share_view                 = [[UIView alloc] initWithFrame:CGRectMake(0, movie_info_background_imageView.bottom, DEVICE_WIDTH, 0)];
        want_share_view.clipsToBounds   = YES;
        want_share_view.backgroundColor = RGBCOLOR(62, 62, 62);
        [section_view addSubview:want_share_view];
        
        UILabel * share_text_label = [ZTools createLabelWithFrame:CGRectMake(30, 0, DEVICE_WIDTH-110, 50)
                                                             text:@"想看标记成功,赶快分享给小伙伴们吧~"
                                                        textColor:[UIColor lightGrayColor]
                                                    textAlignment:NSTextAlignmentLeft
                                                             font:13];
        [want_share_view addSubview:share_text_label];
        
        want_share_button                   = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-100, 12.5, 70, 25)
                                                                      title:@"点击分享"
                                                                      image:nil];
        want_share_button.backgroundColor   = RGBCOLOR(118, 196, 74);
        want_share_button.titleLabel.font   = [ZTools returnaFontWith:13];
        [want_share_button addTarget:self action:@selector(wantToSee:) forControlEvents:UIControlEventTouchUpInside];
        [want_share_view addSubview:want_share_button];
         */
        
        //购票+影片介绍
        buy_ticket_button                   = [ZTools createButtonWithFrame:CGRectMake(16, movie_info_background_imageView.bottom+15, DEVICE_WIDTH-32, 41)
                                                                      title:@"立即购票"
                                                                      image:nil];
        buy_ticket_button.titleLabel.font   = [ZTools returnaFontWith:16];
        buy_ticket_button.backgroundColor   = RGBCOLOR(209, 64, 61);
        [buy_ticket_button addTarget:self action:@selector(buyTicket:) forControlEvents:UIControlEventTouchUpInside];
        [section_view addSubview:buy_ticket_button];
        
        introduction_background_view                = [[UIView alloc] initWithFrame:CGRectMake(0, buy_ticket_button.bottom+10, DEVICE_WIDTH, 85)];
        introduction_background_view.clipsToBounds  = YES;
        [section_view addSubview:introduction_background_view];
        
        introduction_label                  = [[SLabel alloc] initWithFrame:CGRectMake(16, 0, DEVICE_WIDTH-32, 60)
                                                      WithVerticalAlignment:VerticalAlignmentTop];
        introduction_label.font             = [ZTools returnaFontWith:14];
        introduction_label.numberOfLines    = 3;
        [introduction_background_view addSubview:introduction_label];
        //显示介绍详情按钮
        show_detail_button                  = [ZTools createButtonWithFrame:CGRectMake(16, introduction_label.bottom+5, DEVICE_WIDTH-32, 20)
                                                                      title:@""
                                                                      image:nil];
        show_detail_button.backgroundColor  = [UIColor whiteColor];
        [show_detail_button setImage:[UIImage imageNamed:@"movie_show_detail_introduce_down_image"] forState:UIControlStateNormal];
        [show_detail_button setImage:[UIImage imageNamed:@"movie_show_detail_introduce_up_image"] forState:UIControlStateSelected];
        [show_detail_button addTarget:self action:@selector(showIntroductionDetail:) forControlEvents:UIControlEventTouchUpInside];
        [introduction_background_view addSubview:show_detail_button];
    }
    
    
    
    [self setSectionInfo];
}

-(void)setSectionInfo{
    
    if (_movieModel) {
        starRatingView.rating           = _movieModel.scoreNum.intValue/2.0f;
        score_label.text                = [NSString stringWithFormat:@"%@",_movieModel.scoreNum];
        type_label.text                 = _movieModel.movieClass;
        play_area_time_label.text       = [NSString stringWithFormat:@"%@/%@分钟",_movieModel.movieCountry,_movieModel.duration];
        release_date_label.text         = _movieModel.releaseDate;
        introduction_label.text         = _movieModel.movieStory;
        
        NSLog(@"duration -----   %@",_movieModel.duration);
        CGSize introduction_size = [ZTools stringHeightWithFont:introduction_label.font WithString:_movieModel.movieStory WithWidth:introduction_label.width];
        introduction_label.height = introduction_size.height;
        introduction_label.text = _movieModel.movieStory;
        introduction_background_view.height = introduction_label.height;
        
        if (show_detail_button.selected) {
            introduction_background_view.height = introduction_label.height;
        }else{
            introduction_background_view.height = 85;
        }
        
        show_detail_button.bottom = introduction_background_view.height;
        section_view.height = introduction_background_view.bottom;
        
        _myTableView.tableHeaderView = section_view;
    }
    
}


#pragma mark -----  查看影片介绍详情
-(void)showIntroductionDetail:(UIButton*)button{
    button.selected = !button.selected;
    
    if (!_movieModel) {
        return;
    }
    
    NSString * introduction_string = _movieModel.movieStory;
    CGSize introduction_size = [ZTools stringHeightWithFont:introduction_label.font WithString:introduction_string WithWidth:introduction_label.width];

    introduction_label.numberOfLines = button.selected?0:3;
    [UIView animateWithDuration:0.2 animations:^{
        introduction_background_view.height = button.selected?introduction_size.height+25:85;
        show_detail_button.bottom = introduction_background_view.height;
        section_view.height = introduction_background_view.bottom;
        
        _myTableView.tableHeaderView = section_view;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark ------   想看/评分
-(void)wantAndCommentButtonClicked:(UIButton*)button{
    switch (button.tag-100)
    {
        case 0:
        {
            button.selected = !button.selected;
            [UIView animateWithDuration:0.2 animations:^{
                want_share_view.height = button.selected?50:0;
                buy_ticket_button.top = want_share_view.bottom+15;
                introduction_background_view.top = buy_ticket_button.bottom+10;
                section_view.height = introduction_background_view.bottom;
                
                _myTableView.tableHeaderView = section_view;
            } completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        case 1:
        {
            MovieCommentScoreViewController * comment_vc = [[MovieCommentScoreViewController alloc] init];
            UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:comment_vc];
            [self presentViewController:navc animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -----------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = (int)[_dataArray[section] count];
    NSLog(@"count ---   %d",count + (_totalCount<=3?_totalCount==0?1:0:1));
    return count + (_totalCount<=3?_totalCount==0?1:0:1);
    /*
    if (section == 0) {
        return _dataArray.count+1;
    }else if (section == 1){
        return _dataArray.count+1;
    }
    return 3;
     */
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    /*
    return 2;
     */
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;
    
    if (indexPath.section == 0 && indexPath.row < [_dataArray[indexPath.section] count]) {
        NSString * identifier       = @"comments";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell                    = [[MovieComentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        MovieCommentsModel * model  = _dataArray[indexPath.section][indexPath.row];
        
        [(MovieComentTableViewCell*)cell setInfomationWithMovieCommentsModel:model];
        
    }else if(indexPath.section == 1 && indexPath.row < [_dataArray[indexPath.section] count]){
        NSString * identifier       = @"topic";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        MovieTopicModel * model     = [[MovieTopicModel alloc] init];
        model.content               = _dataArray[indexPath.section][indexPath.row];
        model.title                 = @"《美人鱼》票房多少了啊？";
        
        [(TopicTableViewCell*)cell setInfomationMovieTopicModel:model];
    }else{
        NSString * identifier = @"extention";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        UIButton * button       = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame            = CGRectMake(0, 0, DEVICE_WIDTH, 40);
        button.tag              = 10000 + indexPath.section;
        [button setTitle:[_dataArray[indexPath.section] count]?(indexPath.section==0?[NSString stringWithFormat:@"查看全部%d条评论",_totalCount]:@"查看全部话题"):(indexPath.section==0?@"暂无评论，赶快去评个分吧":@"暂无话题，我要第一个发表") forState:UIControlStateNormal];
        button.titleLabel.font  = [ZTools returnaFontWith:14];
        button.userInteractionEnabled = NO;
        [button setTitleColor:RGBCOLOR(241, 51, 47) forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
    }
    cell.selectionStyle         = UITableViewCellSelectionStyleNone;
   return cell;
}

-(void)loadNewData{
    self.myTableView.pageNum = 0;
    [self loadMovieData];
    [self loadCommentsData];
}

- (void)loadMoreData{
    [self loadCommentsData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row < [_dataArray[indexPath.section] count]) {
        
    }else if(indexPath.section == 1 && indexPath.row < [_dataArray[indexPath.section] count]){
        MovieTopicModel * model                 = [[MovieTopicModel alloc] init];
        MovieTopicDetailViewController * VC     = [[MovieTopicDetailViewController alloc] init];
        VC.topicModel                           = model;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        if (indexPath.section == 0 && _totalCount > 3) {
            MovieCommentsListViewController * viewController = [[MovieCommentsListViewController alloc] init];
            viewController.movieModel = _movie_list_model;
            [self.navigationController pushViewController:viewController animated:YES];
        }else if(indexPath.section == 1 && [_dataArray[indexPath.section] count] > 3){
            MovieTopicListViewController * viewController = [[MovieTopicListViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row >= [_dataArray[indexPath.section] count]) {
            return 40;
        }else{
            MovieCommentsModel * model = _dataArray[indexPath.section][indexPath.row];
            CGSize content_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15] WithString:model.content WithWidth:DEVICE_WIDTH-32];
            return 90+content_size.height;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row >= [_dataArray[indexPath.section] count]) {
            return 40;
        }else{
            MovieTopicModel * model = _dataArray[indexPath.section][indexPath.row];
            CGSize content_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:13] WithString:model.content WithWidth:DEVICE_WIDTH-32];
            return 102+content_size.height;
        }
    }
    return 90;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section{
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UIView * separator_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 10)];
    separator_view.backgroundColor = RGBCOLOR(245, 245, 245);
    [sectionView addSubview:separator_view];
    
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, sectionView.bottom-0.5, DEVICE_WIDTH, 0.5)];
    line_view.backgroundColor = RGBCOLOR(237, 237, 237);
    [sectionView addSubview:line_view];
    
    UILabel * content_title_label = [ZTools createLabelWithFrame:CGRectMake(16, separator_view.bottom, 100, sectionView.height-separator_view.height) text:section==0?@"影评":@"话题" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:14];
    [sectionView addSubview:content_title_label];
    
    UIButton * publish_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-60-16, 17.5, 60, 25) title:section==0?@"发影评":@"发话题" image:nil];
    publish_button.layer.borderColor = RGBCOLOR(201, 54, 55).CGColor;
    publish_button.layer.borderWidth = 0.5;
    [publish_button setTitleColor:RGBCOLOR(201, 54, 55) forState:UIControlStateNormal];
    publish_button.titleLabel.font = [ZTools returnaFontWith:14];
    publish_button.backgroundColor = [UIColor whiteColor];
    publish_button.tag = 10000 + section;
    [publish_button addTarget:self action:@selector(publishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:publish_button];

    return sectionView;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.myTableView)
    {
        CGFloat sectionHeaderHeight = 50;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


#pragma mark -------  发表话题或影评
-(void)publishButtonClicked:(UIButton*)button{
    
    if (![ZTools isLogIn]) {
        /*张少南
        UIStoryboard *storyboard        = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController * login  = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
        [self presentViewController:login animated:YES completion:nil];
        */
        [[LogInView sharedInstance] loginShowWithSuccess:nil];
        
        return;
    }
    
    switch (button.tag - 10000) {
        case 0://影评
        {
            [MobClick event:@"MovieComments"];
            
            MPublishCommentViewController * viewController  = [[MPublishCommentViewController alloc] init];
            viewController.movieId                          = _movie_list_model.movieId;
            UINavigationController * navc                   = [[UINavigationController alloc] initWithRootViewController:viewController];;
            [self presentViewController:navc animated:YES completion:nil];
        }
            break;
        case 1://话题
        {
            MPublishTopicViewController * viewController = [[MPublishTopicViewController alloc] init];
            
            UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self presentViewController:navc animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -------  想看
-(void)wantToSee:(UIButton*)button{
    
}

#pragma mark -------  购票
-(void)buyTicket:(UIButton *)button{
    MNearByCinemasViewController * cinema_vc = [[MNearByCinemasViewController alloc] init];
    cinema_vc.movieModel = _movie_list_model;
    [self.navigationController pushViewController:cinema_vc animated:YES];
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
