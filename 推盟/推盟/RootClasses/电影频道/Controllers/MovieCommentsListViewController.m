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
@property(nonatomic,strong)NSArray              * content_array;
@property(nonatomic,strong)NSMutableArray       * rowHeightArray;

@end

@implementation MovieCommentsListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = _movieModel.movieName;
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"发影评"];
    
    _content_array = @[@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加",@"较大时了解到拉开车那臭小子差那么差那么在新农村能吃么展现出你每次你怎么才能在每次",@"就打死了较大时来得及阿来得及阿里是看得见啊考虑到建档立卡手机打开垃圾是邓丽君阿拉丁就对啦出租车在沉默中每次在每次出门早就打打开了建档立卡圣诞节阿卡丽的长期而抛弃未破千万IE抛弃我怕",@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加",@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加",@"就打死了较大时来得及阿来得及阿里是看得见啊考虑到建档立卡手机打开垃圾是邓丽君阿拉丁就对啦出租车在沉默中每次在每次出门早就打打开了建档立卡圣诞节阿卡丽的长期而抛弃未破千万IE抛弃我怕",@"就打死了较大时来得及阿来得及阿里是看得见啊考虑到建档立卡手机打开垃圾是邓丽君阿拉丁就对啦出租车在沉默中每次在每次出门早就打打开了建档立卡圣诞节阿卡丽的长期而抛弃未破千万IE抛弃我怕",@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加",@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加",@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加",@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加",@"巨大空间的拉开进度款拉斯加达拉斯就打算离开的就卡了打开了上加大了快速解答了肯德基阿拉坤的叫撒刻录机大山里的骄傲了肯德基啊快乐大脚阿斯利康手动加"];
    _rowHeightArray                 = [NSMutableArray array];

    
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [self.view addSubview:_myTableView];
    
}

#pragma mark ---- 发影评
-(void)rightButtonTap:(UIButton *)sender{
    MPublishCommentViewController * viewController = [[MPublishCommentViewController alloc] init];
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
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    MovieComentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MovieComentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MovieCommentsModel * model = [[MovieCommentsModel alloc] init];
    model.content = _content_array[indexPath.row];
    
    [cell setInfomationWithMovieCommentsModel:model];

    return cell;
}

-(void)loadNewData{
    
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    CGSize content_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15] WithString:_content_array[indexPath.row] WithWidth:DEVICE_WIDTH-32];
    return 90+content_size.height;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section{
    if (!section_view) {
        section_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        section_view.backgroundColor = [UIColor whiteColor];
        
        all_comments_num_label = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-30, 40) text:@"共49900条评论" textColor:RGBCOLOR(31, 31, 31) textAlignment:NSTextAlignmentLeft font:15];
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





















