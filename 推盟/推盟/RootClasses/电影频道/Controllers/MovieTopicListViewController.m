//
//  MovieTopicViewController.m
//  推盟
//
//  Created by joinus on 16/3/9.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieTopicListViewController.h"
#import "TopicTableViewCell.h"
#import "MPublishTopicViewController.h"
#import "MovieTopicDetailViewController.h"

@interface MovieTopicListViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    UIView  * section_view;
    UILabel * all_comments_num_label;
}


@property(nonatomic,strong)SNRefreshTableView   * myTableView;
@property(nonatomic,strong)NSMutableArray       * dataArray;
@property(nonatomic,strong)NSMutableArray       * rowHeightArray;


@end

@implementation MovieTopicListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"美人鱼";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"发话题"];
    
    _dataArray = [NSMutableArray array];
    
    
    for (int i = 0; i < 5; i++) {
        MovieTopicModel * model = [[MovieTopicModel alloc] init];
        model.content = @"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加";
        model.images = [NSMutableArray arrayWithObjects:@"http://hiphotos.baidu.com/praisejesus/pic/item/e8df7df89fac869eb68f316d.jpg",@"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg",nil];
        model.title = @"《美人鱼》里有哪些不经意但有趣的细节？《美人鱼》里有哪些不经意但有趣的细节？《美人鱼》里有哪些不经意但有趣的细节？";
        [_dataArray addObject:model];
    }
    
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
}

#pragma mark -----  发表话题
-(void)rightButtonTap:(UIButton *)sender{
    MPublishTopicViewController * viewController = [[MPublishTopicViewController alloc] init];
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:viewController];;
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark ------  网络请求
-(void)loadCommentsListData{
    
    [[ZAPI manager] sendPost:GET_MOVIE_COMMENTS_URL myParams:@{@"movieId":@"",@"lastCommentId":@"",@"pageRowCount":@"20"} success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ------   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    TopicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MovieTopicModel * model = _dataArray[indexPath.row];
    
    [cell setInfomationMovieTopicModel:model];
    
    return cell;
}

-(void)loadNewData{
    
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieTopicModel * model = _dataArray[indexPath.row];

    MovieTopicDetailViewController * VC = [[MovieTopicDetailViewController alloc] init];
    VC.topicModel = model;
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    MovieTopicModel * model = _dataArray[indexPath.row];

    CGSize content_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:13] WithString:model.content WithWidth:DEVICE_WIDTH-32];
    return 102+content_size.height;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section{
    if (!section_view) {
        section_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        section_view.backgroundColor = [UIColor whiteColor];
        
        all_comments_num_label = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-30, 40) text:@"共49900条话题" textColor:RGBCOLOR(31, 31, 31) textAlignment:NSTextAlignmentLeft font:15];
        [section_view addSubview:all_comments_num_label];
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, section_view.bottom-0.5, DEVICE_WIDTH, 0.5)];
        line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [section_view addSubview:line_view];
    }
    
    return section_view;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    return 40;
}

@end







