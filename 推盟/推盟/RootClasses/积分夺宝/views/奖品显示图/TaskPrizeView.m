//
//  TaskPrizeView.m
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "TaskPrizeView.h"
#import "MyPrizeModel.h"

@interface TaskPrizeView ()<UITableViewDelegate,UITableViewDataSource,TaskPrizeCellConvertDelegate>{
    
}

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataArray;


@end

@implementation TaskPrizeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray array];
        [self creatUI];
    }
    
    return self;
}

-(void)creatUI{
    _tableView                  = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.scrollEnabled    = NO;
    _tableView.delegate         = self;
    _tableView.dataSource       = self;
    _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self);
    }];
}

-(void)setInfoWithArray:(NSMutableArray *)prizes{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:prizes];
    [_tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    TaskPrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[TaskPrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    PrizeStatusModel * model = _dataArray[indexPath.row];
    
    [cell setInfomationWithPrizeModel:model];
    
    return cell;
}

#pragma mark ------  立即兑换按钮
-(void)convertClicked:(TaskPrizeCell *)cell{
    if (_delegate && [_delegate respondsToSelector:@selector(convertClicked:)]) {
        NSIndexPath * indexP = [_tableView indexPathForCell:cell];
        PrizeStatusModel * model = _dataArray[indexP.row];
        [_delegate convertClicked:model];
    }
}


@end







