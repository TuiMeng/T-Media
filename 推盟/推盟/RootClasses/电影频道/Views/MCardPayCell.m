//
//  MCardPayCell.m
//  推盟
//
//  Created by joinus on 16/3/29.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MCardPayCell.h"

@implementation MCardPayCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_backView) {
            _backView                   = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 140)];
            _backView.backgroundColor   =  [UIColor whiteColor];
            [self.contentView addSubview:_backView];
        }
        
        if (!_cardNumTextField) {
            _cardNumTextField       = [self createTextFieldWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 42.5) font:15 placeHolder:@"请输入序列号" secureTextEntry:NO];
            [_backView addSubview:_cardNumTextField];
        }
        
        if (!_separatorView1) {
            _separatorView1                      = [[SView alloc] initWithFrame:CGRectMake(0, _cardNumTextField.bottom, DEVICE_WIDTH, 10)];
            _separatorView1.backgroundColor      = RGBCOLOR(245, 245, 245);
            _separatorView1.lineColor            = RGBCOLOR(224, 224, 224);
            _separatorView1.isShowTopLine        = YES;
            _separatorView1.isShowBottomLine     = YES;
            [_backView addSubview:_separatorView1];
            
        }
        
        if (!_cardPWTextField) {
            _cardPWTextField                = [self createTextFieldWithFrame:CGRectMake(0, _separatorView1.bottom, DEVICE_WIDTH, 42.5) font:15 placeHolder:@"支付密码" secureTextEntry:YES];
            [_backView addSubview:_cardPWTextField];
            
            UIView * lineView               = [[UIView alloc] initWithFrame:CGRectMake(0, _cardPWTextField.height-0.5, DEVICE_WIDTH, 0.5)];
            lineView.backgroundColor        = RGBCOLOR(224, 224, 224);
            lineView.userInteractionEnabled = NO;
            [_cardPWTextField addSubview:lineView];
        }
                
        if (!_cardInfoLabel) {
            _cardInfoLabel = [ZTools createLabelWithFrame:CGRectMake(15, _cardPWTextField.bottom+10, DEVICE_WIDTH-30, 20) text:@"" textColor:RGBCOLOR(98, 98, 98) textAlignment:NSTextAlignmentCenter font:12];
            _cardInfoLabel.hidden = YES;
            [_backView addSubview:_cardInfoLabel];
        }
        
        if (!_doneButton) {
            _doneButton                     = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-95, _cardPWTextField.bottom+10, 80, 30)
                                                                      title:@"确认"
                                                                      image:nil];
            _doneButton.titleLabel.font     = [ZTools returnaFontWith:14];
            [_doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
            [_backView addSubview:_doneButton];
        }
        
        if (!_removeButton) {
            _removeButton                   = [ZTools createButtonWithFrame:CGRectMake(15, _doneButton.top, 100, _doneButton.height)
                                                                      title:@"不使用此电影卡"
                                                                      image:nil];
            _removeButton.backgroundColor   = [UIColor whiteColor];
            _removeButton.titleLabel.font   = [ZTools returnaFontWith:12];
            [_removeButton setTitleColor:RGBCOLOR(251, 48, 60) forState:UIControlStateNormal];
            [_removeButton addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
            [_backView addSubview:_removeButton];
        }
    }
    
    return self;
}

-(void)setPayDoneBlock:(MCardPayDoneBlock)dBlock remove:(MCardPayRemoveBlock)rBlock{
    doneBlock       = dBlock;
    removeBlock     = rBlock;
}
-(void)done:(UIButton *)button{
    
    doneBlock(self.cardNumTextField.text,self.cardPWTextField.text,[button.titleLabel.text isEqualToString:@"添加"]);
}
-(void)remove:(UIButton*)button{
    removeBlock();
}

-(void)setInfomationWithCardModel:(id)info WithType:(int)type withPrice:(float)price{
    
    _cardPWTextField.placeholder        = (type==0||type==1)?@"请输入支付密码":@"请输入票面密码";
    _cardNumTextField.placeholder       = (type==0||type==1)?@"请输入顺序号":@"请输入序列号";
    
    
    MCardModel * model = (MCardModel *)info;
    
    BOOL isTure = (model && [model isKindOfClass:[MCardModel class]]);
    _cardNumTextField.text      = isTure?model.sequenceNo:@"";
    _cardPWTextField.text       = isTure?model.secretNo:@"";
    _cardInfoLabel.hidden       = !isTure;
    _doneButton.top             = isTure?(_cardInfoLabel.bottom+5):(_cardPWTextField.bottom+10);
    _removeButton.hidden        = !isTure;
    _removeButton.top           = _doneButton.top;
    [_doneButton setTitle:isTure?@"添加":@"确定" forState:UIControlStateNormal];
    _backView.height            = isTure?170:140;
    
    if (type == 2)//兑换券
    {
        _cardInfoLabel.text         = isTure?[NSString stringWithFormat:@"卡状态：%@          剩余次数：%@          单次金额：%@",model.status,model.curval,model.localval]:@"";
        //判断钱数够得话，隐藏添加按钮
        _doneButton.hidden          = isTure?([model.curval intValue]*[model.localval intValue] > price?YES:NO):NO;
    }else if(type == 0)//储值卡
    {
        _cardInfoLabel.text         = isTure?[NSString stringWithFormat:@"卡状态：%@                余额：%@",model.status,model.curval]:@"";
        //只允许使用一张储值卡
        _doneButton.hidden          = isTure;
    }else if(type == 1)//计次卡
    {
        _cardInfoLabel.text         = isTure?[NSString stringWithFormat:@"卡状态：%@          剩余次数：%@          单次金额：%@",model.status,model.curval,model.localval]:@"";
        //只允许使用一张计次卡
        _doneButton.hidden          = isTure;
    }
}

-(STextField *)createTextFieldWithFrame:(CGRect)frame font:(float)font placeHolder:(NSString *)placeHolder secureTextEntry:(BOOL)secure{
    STextField * textField = [[STextField alloc] initWithFrame:frame];
    textField.font = [ZTools returnaFontWith:font];
    textField.placeholder = placeHolder;
    textField.secureTextEntry = secure;
    return textField;
}








@end
