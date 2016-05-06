//
//  MovieCommentsListViewController.m
//  推盟
//
//  Created by joinus on 16/3/9.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieCommentsListViewController.h"
#import "MovieComentTableViewCell.h"
#import "MovieTopicModel.h"
#import "MPublishCommentViewController.h"

@interface MovieCommentsListViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    UIView * section_view;
    UILabel * all_comments_num_label;
}


@property(nonatomic,strong)SNRefreshTableView   * myTableView;
@property(nonatomic,strong)NSMutableArray       * rowHeightArray;

@property(nonatomic,strong)NSMutableArray       * dataArray;
@property(nonatomic,assign)int                  totalCount;

@end

@implementation MovieCommentsListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = _movieModel.movieName;
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"发影评"];
    
    _rowHeightArray                 = [NSMutableArray array];
    _dataArray                      = [NSMutableArray array];
    
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.isHaveMoreData     = YES;
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    _myTableView.pageNum            = 0;
    [self.view addSubview:_myTableView];
    
    
    [self loadCommentsData];
}

#pragma mark ---- 发影评
-(void)rightButtonTap:(UIButton *)sender{
    MPublishCommentViewController * viewController = [[MPublishCommentViewController alloc] init];
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:viewController];;
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark ------  网络请求
-(void)loadCommentsData{
    
    __WeakSelf__ wself = self;
    
    NSDictionary * dic = @{@"movieId":_movieModel.movieId,
                           @"pageId":@(_myTableView.pageNum),
                           @"pageSize":@"10"};
    
    [[ZAPI manager] sendPost:GET_MOVIE_COMMENTS_URL myParams:dic success:^(id data) {
        
        if (wself.myTableView.pageNum == 0) {
            [wself.dataArray        removeAllObjects];
            [wself.rowHeightArray   removeAllObjects];
        }
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[MOVIE_ERROR_CODE] intValue] == 0) {
                wself.totalCount = [data[@"count"] intValue];
                NSArray * array = data[@"datas"];
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    for (NSDictionary * item in array) {
                        MovieCommentsModel * model = [[MovieCommentsModel alloc] initWithDictionary:item];
                        [wself.dataArray addObject:model];
                        
                        CGSize content_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15]
                                                                WithString:model.content
                                                                 WithWidth:DEVICE_WIDTH-32];
                        [wself.rowHeightArray addObject:@(90+content_size.height)];
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


#pragma mark ------   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    MovieComentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MovieComentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MovieCommentsModel * model = _dataArray[indexPath.row];
    
    [cell setInfomationWithMovieCommentsModel:model];

    return cell;
}

-(void)loadNewData{
    _myTableView.pageNum = 0;
    [self loadCommentsData];
}
- (void)loadMoreData{
    //判断是否已经加载完所有数据
    if (self.dataArray.count == self.totalCount && self.totalCount != 0) {
        self.myTableView.isHaveMoreData = NO;
        [self.myTableView finishReloadigData];
        return ;
    }
    [self loadCommentsData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return [_rowHeightArray[indexPath.row] floatValue];
}
- (UIView *)viewForHeaderInSection:(NSInteger)section{
    if (!section_view) {
        section_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        section_view.backgroundColor = [UIColor whiteColor];
        
        all_comments_num_label = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-30, 40) text:[NSString stringWithFormat:@"共%d条评论",_totalCount] textColor:RGBCOLOR(31, 31, 31) textAlignment:NSTextAlignmentLeft font:15];
        [section_view addSubview:all_comments_num_label];
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, section_view.bottom-0.5, DEVICE_WIDTH, 0.5)];
        line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [section_view addSubview:line_view];
    }
    
    all_comments_num_label.text = [NSString stringWithFormat:@"共%d条评论",_totalCount];
    
    return section_view;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    return 40;
}


-(void)dealloc{
    _myTableView = nil;
    _dataArray = nil;
    _rowHeightArray = nil;
}

@end





















