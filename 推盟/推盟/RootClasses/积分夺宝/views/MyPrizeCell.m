//
//  MyPrizeCell.m
//  推盟
//
//  Created by joinus on 16/6/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyPrizeCell.h"

#define INDENT 15
#define BLACK_TEXT_CLOLOR RGBCOLOR(73,73,73)

@interface MyPrizeCell ()

@property(nonatomic,strong)MyPrizeModel * prizeModel;

@end

@implementation MyPrizeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_backView) {
            _backView = [[UIView alloc] initWithFrame:CGRectMake(INDENT, 0, DEVICE_WIDTH-INDENT*2, 65)];
            _backView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
            _backView.layer.borderWidth = 0.5;
            [self.contentView addSubview:_backView];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTaskContent:)];
            [_backView addGestureRecognizer:tap];
        }
        
        if (!_titleView) {
            _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, 20)];
            _titleView.backgroundColor = RGBCOLOR(251, 142, 145);
            [_backView addSubview:_titleView];
        }
        
        
        if (!_taskNameLabel) {
            _taskNameLabel = [ZTools createLabelWithFrame:CGRectMake(5, 0, _backView.width - 10, 20)
                                                      text:@""
                                                 textColor:[UIColor whiteColor]
                                             textAlignment:NSTextAlignmentLeft
                                                      font:14];
            [_titleView addSubview:_taskNameLabel];
        }
        
        if (!_prizeView) {
            _prizeView = [[TaskPrizeView alloc] init];
            _prizeView.delegate = self;
            [_backView addSubview:_prizeView];
        }
        
        
        if (!_clickAndLotteryNum) {
            _clickAndLotteryNum = [ZTools createLabelWithFrame:CGRectMake(INDENT, _backView.bottom, 80, 20)
                                                       text:@""
                                                  textColor:BLACK_TEXT_CLOLOR
                                              textAlignment:NSTextAlignmentLeft
                                                       font:10];
            [self.contentView addSubview:_clickAndLotteryNum];
        }
        
        
        //Add AutoLayOut
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16.0f);
            make.right.equalTo(self.contentView).offset(-16.0f);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        
        
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView);
            make.right.equalTo(_backView);
            make.top.equalTo(_backView);
            make.height.equalTo(@20);
        }];
        
        [_taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(_titleView).offset(5);
            make.top.and.bottom.equalTo(_titleView);
        }];
        
        [_prizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(@0);
            make.top.equalTo(_titleView.mas_bottom);
            make.height.equalTo(@165);
        }];
        
        [_clickAndLotteryNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-16.0f);
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(_backView.mas_bottom);
            make.height.equalTo(@20);
        }];
        
    }
    return self;
}

-(void)setInfomationWithMyPrizeModel:(MyPrizeModel *)model
                       getPrizeBlock:(MyPrizeCellGetPrizeBlock)gBlock
                lookTaskContentBlock:(MyPrizeCellLookTaskContentBlock)lBlock{

    getBlock = gBlock;
    lookBlock = lBlock;
    _prizeModel = model;
    
    _taskNameLabel.text = model.task_name;    

    [_prizeView setInfoWithArray:model.prizes];
    
    [_prizeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(model.prizes.count*55));
    }];
    
    //点击/抽奖次数
    NSString * num = [NSString stringWithFormat:@"点击：%@次  抽奖：%@次",model.all_click,model.drawed_num];
    _clickAndLotteryNum.text = num;
}

-(void)convertClicked:(NSString *)prizeId{
    if (getBlock) {
        getBlock(prizeId);
    }
}

//#pragma mark ---  查看/领取奖品
//-(void)lookButtonClicked:(UIButton *)button{
//    if (_prizeModel.canAcceptPrize.integerValue) {
//        if (getBlock) {
//            getBlock();
//        }
//    }else{
//        if (lookBlock) {
//            lookBlock();
//        }
//    }
//    
//}

#pragma mark ----- 查看任务详情
-(void)showTaskContent:(UITapGestureRecognizer *)sender{
    if (lookBlock) {
        lookBlock();
    }
}

#pragma mark ------  处理状态值
-(NSString *)handleStatusWith:(NSString *)status{
    if (status.integerValue == 0) {
        return @"状态:审核中";
    }else if (status.intValue == 1) {
        return @"状态:已发放";
    }else if (status.intValue == 2) {
        return @"状态:已拒绝";
    }
    return @"";
}
//-(NSString *)returnPlatformString{
//    if (_prizeModel.isVirtual.intValue && _prizeModel.status.intValue == 2) {
//        return _prizeModel.reason;
//    }
//    
//    if (!_prizeModel.isVirtual.intValue) {
//        if (_prizeModel.status.intValue == 1) {
//            return [NSString stringWithFormat:@"物流：圆通 运单号：123456789012"];
//        }else if (_prizeModel.status.intValue == 2)  {
//            return _prizeModel.reason;
//        }
//    }
//    return @"";
//}

@end








