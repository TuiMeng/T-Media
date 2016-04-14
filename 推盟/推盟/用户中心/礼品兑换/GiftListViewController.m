//
//  GiftListViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "GiftListViewController.h"
#import "GiftDetailViewController.h"
#import "CycleScrollView.h"
#import "CycleScrollModel.h"
#import "GiftListCell.h"
#import "GiftListModel.h"
#import "FocusImageModel.h"

@interface GiftListViewController ()<UITableViewDataSource,SNRefreshDelegate>{
    
}

@property(nonatomic,strong)NSMutableArray * c_array;
@property(nonatomic,strong)NSMutableArray * c_image_array;
@property(nonatomic,strong)NSMutableArray * c_title_array;
@property(nonatomic,strong)NSMutableArray * data_array;
@property (weak, nonatomic) IBOutlet SNRefreshTableView *myTableView;
@property(nonatomic,strong)SDCycleScrollView * c_scrollView;
@property(nonatomic,strong)UIView * header_view;

@end

@implementation GiftListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"礼品兑换";
    
    _data_array = [NSMutableArray array];
    
    _myTableView.refreshDelegate = self;
    _myTableView.isHaveMoreData = YES;
    _myTableView.dataSource = self;
    _myTableView.sectionHeaderHeight = 215;
    _myTableView.separatorColor = RGBCOLOR(167, 167, 167);
//    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self startLoading];
    
    [self loadFocusData];
    [self loadGiftListData];
}

#pragma mark ------   数据加载 ----------
-(void)loadGiftListData{
    __weak typeof(self)wself = self;
    
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&page=%d",GIFT_LIST_URL,_myTableView.pageNum] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            
            if (wself.myTableView.pageNum == 1) {
                wself.myTableView.isHaveMoreData = YES;
                [wself.data_array removeAllObjects];
            }
            
            NSString * status = [data objectForKey:@"status"];
            if (status.intValue == 1) {
                NSArray * array = [data objectForKey:@"list"];
                if (array && [array isKindOfClass:[NSArray class]]) {
                    for (NSDictionary * dic in array) {
                        GiftListModel * model = [[GiftListModel alloc] initWithDictionary:dic];
                        [wself.data_array addObject:model];
                    }
                }else{
                    wself.myTableView.isHaveMoreData = NO;
                }
                
            }else{
                
            }
            [wself.myTableView finishReloadigData];
        }
    } failure:^(NSError *error) {
        [wself endLoading];
        [wself.myTableView finishReloadigData];
    }];
}
-(void)loadFocusData{
    
    if (!_c_array) {
        _c_array = [NSMutableArray array];
        _c_image_array = [NSMutableArray array];
         _c_title_array = [NSMutableArray array];
    }
    [_c_array removeAllObjects];
    [_c_title_array removeAllObjects];
    [_c_image_array removeAllObjects];
    
    __weak typeof(self)wself = self;
    
    
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&type=%@",GIFT_FOCUS_IMAGES_URL,@"gift"] success:^(id data) {
        [self endLoading];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSArray * array = [data objectForKey:@"Focus_img"];
            
            for (NSDictionary * dic in array) {
                
                FocusImageModel * model = [[FocusImageModel alloc] initWithDictionary:dic];
                [wself.c_array addObject:model];
                [wself.c_image_array addObject:model.focus_img];
                [wself.c_title_array addObject:model.title];
            }
            [wself createCycleScrollView];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

#pragma mark =============   创建轮播图   ===============
-(void)createCycleScrollView{
    
    if (!_header_view) {
        _header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 250)];
        _header_view.backgroundColor = [UIColor whiteColor];
        [ZTools getInvitationCode];
        _c_scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,DEVICE_WIDTH,[ZTools autoHeightWith:180]) imageURLStringsGroup:_c_image_array];
        _c_scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _c_scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _c_scrollView.autoScrollTimeInterval = 5.f;
        
        UIImage * image = [UIImage imageNamed:@"gift_all_money_image"];
        NSString * money_string = [NSString stringWithFormat:@"余额:%@",[ZTools getRestMoney]];
        CGSize money_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15] WithString:money_string WithWidth:MAXFLOAT];
        
        UIButton * all_money_button = [UIButton buttonWithType:UIButtonTypeCustom];
        all_money_button.frame = CGRectMake(15, _c_scrollView.bottom+10, image.size.width+money_size.width+30, 30);
        [all_money_button setImage:image forState:UIControlStateNormal];
        all_money_button.titleLabel.font = [ZTools returnaFontWith:15];
        [all_money_button setTitle:money_string forState:UIControlStateNormal];
        [all_money_button setTitleColor:RGBCOLOR(42, 42, 42) forState:UIControlStateNormal];
        [all_money_button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
        [all_money_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        UIButton * record_button = [UIButton buttonWithType:UIButtonTypeCustom];
        record_button.frame = CGRectMake(DEVICE_WIDTH - 115, _c_scrollView.bottom+10, 100, 30);
        record_button.titleLabel.font = [ZTools returnaFontWith:15];
        [record_button setImage:[UIImage imageNamed:@"gift_record_image"] forState:UIControlStateNormal];
        [record_button setTitle:@"兑换记录" forState:UIControlStateNormal];
        [record_button setTitleColor:RGBCOLOR(42, 42, 42) forState:UIControlStateNormal];
        [record_button addTarget:self action:@selector(recordButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [record_button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
        [record_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        
        _header_view.height = record_button.bottom + 10;
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, _header_view.height-0.5, DEVICE_WIDTH, 0.5)];
        line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [_header_view addSubview:line_view];
        
        [_header_view addSubview:_c_scrollView];
        [_header_view addSubview:all_money_button];
        [_header_view addSubview:record_button];
    }
    
    _c_scrollView.imageURLStringsGroup = _c_image_array;
    _c_scrollView.titlesGroup = _c_title_array;

    _myTableView.tableHeaderView = _header_view;
}

#pragma mark ---------------  UITableView Delegate  ------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row = (int)(_data_array.count/2 + (_data_array.count%2?1:0));
    
    return row;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GiftListCell * cell = (GiftListCell*)[tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    GiftListModel * model1 = _data_array[indexPath.row*2];
    GiftListModel * model2;
    if (_data_array.count > indexPath.row*2+1) {
        model2 = _data_array[(indexPath.row*2+1)];
    }
    
    [cell setGiftOneWith:model1 TwoWith:model2];
    
//    if (indexPath.row*2 == _data_array.count-1 || indexPath.row*2+1 == _data_array.count) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,149.5,DEVICE_WIDTH,0.5)];
        view.backgroundColor = RGBCOLOR(167, 167, 167);
        [cell addSubview:view];
//    }
    
    [cell leftClicked:^{
        [self performSegueWithIdentifier:@"showGiftDetailSegue" sender:model1.id];
    } rightClicked:^{
        [self performSegueWithIdentifier:@"showGiftDetailSegue" sender:model2.id];
    }];
    
    return cell;
}

#pragma mark -------  Refresh Delegate
- (void)loadNewData{
    [self loadGiftListData];
    [self loadFocusData];
}
- (void)loadMoreData{
    [self loadGiftListData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


#pragma mark -------------------  兑换记录按钮
-(void)recordButtonTap:(UIButton*)sender{
    [self performSegueWithIdentifier:@"showConversionListSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGiftDetailSegue"]) {
        GiftDetailViewController * viewcontroller = (GiftDetailViewController*)segue.destinationViewController;
        [viewcontroller setValue:sender forKey:@"gift_id"];
    }
}


@end
