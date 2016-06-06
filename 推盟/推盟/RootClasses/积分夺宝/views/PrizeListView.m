//
//  PrizeListView.m
//  推盟
//
//  Created by joinus on 16/6/3.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeListView.h"
#import "PrizeCell.h"
#import "PrizeModel.h"

@interface PrizeListView ()<SNRefreshDelegate,UITableViewDataSource>{
    
}


@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)NSMutableArray       * dataArray;

@property(nonatomic,strong)PrizeModel           * model;

@end


@implementation PrizeListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMainView];
        
    }
    
    return self;
}

-(PrizeModel *)model{
    if (_model == nil) {
        _model = [PrizeModel sharedInstance];
    }
    return _model;
}


-(void)getData{
    __WeakSelf__ wself = self;
    [self.model loadDataWithPage:_myTableView.pageNum withSuccess:^(NSMutableArray *array) {
        
    } withFailure:^(NSString *error) {
        [ZTools showMBProgressWithText:error WihtType:MBProgressHUDModeText addToView:wself isAutoHidden:YES];
    }];
}

#pragma mark ---  创建主视图
-(void)createMainView{
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:self.bounds showLoadMore:YES];
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [self addSubview:_myTableView];
}


#pragma mark -------  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)loadNewData{
    
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 125;
}



@end
