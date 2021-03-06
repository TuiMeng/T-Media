//
//  LotteryView.m
//  推盟
//
//  Created by joinus on 16/6/15.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "LotteryView.h"
#import "UserInfoModel.h"

@interface LotteryView (){
    UITextView * addressTextView;
    UIButton * doneButton;
    UIButton * modifyAddressButton;
    UILabel * userNameLabel;
}

/**
 *  抽奖视图
 */
@property(nonatomic,strong)UIImageView * lotteryImageView;
/**
 *  中奖视图
 */
@property(nonatomic,strong)UIImageView * winnerView;
/**
 *  未中奖视图
 */
@property(nonatomic,strong)UIImageView * failedView;
/**
 *  兑换视图
 */
@property(nonatomic,strong)UIImageView * convertView;


@end

@implementation LotteryView

+(instancetype)sharedInstance{
    return [[[self class] alloc] init];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self createMainView];
    }
    return self;
}
#pragma mark ------  创建主视图
-(void)createMainView{
    [self addSubview:self.lotteryImageView];
    
    
}

-(UIImageView *)lotteryImageView{
    if (!_lotteryImageView) {
        _lotteryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lottery_box_image"]];
        _lotteryImageView.center = CGPointMake(DEVICE_WIDTH/2.0f, DEVICE_HEIGHT/2.0f);
        _lotteryImageView.userInteractionEnabled = YES;
    }
    return _lotteryImageView;
}
-(UIImageView *)winnerView{
    if (!_winnerView) {
        _winnerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lottery_winning_image"]];
        _winnerView.center = self.center;
        _winnerView.userInteractionEnabled = YES;
    }
    return _winnerView;
}

-(UIImageView *)failedView{
    if (!_failedView) {
        _failedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lottery_failed_image"]];
        _failedView.center = self.center;
        _failedView.userInteractionEnabled = YES;
    }
    return _failedView;
}
-(UIImageView *)convertView{
    if (!_convertView) {
        _convertView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prize_convert_confirm_image"]];
        _convertView.center = self.center;
        _convertView.userInteractionEnabled = YES;
    }
    return _convertView;
}

#pragma mark ------  抽奖动画
-(void)loadingAnimation{
    [self shakingAnimation];
}
#pragma mark -------  中奖视图
-(void)showWinnerViewWithPrizeName:(NSString *)name
                         isVirtual:(BOOL)isVirtual
                      convertBlock:(LotteryViewConvertBlock)cBlock
                       modifyBlock:(LotteryViewModifyAddressBlock)mBlock{
    convertBlock = cBlock;
    modifyBlock = mBlock;
    
    [_lotteryImageView.layer removeAllAnimations];
    [_lotteryImageView removeFromSuperview];
    _lotteryImageView = nil;
    
    [self addSubview:self.winnerView];
    
    UILabel * prizeNameLabel = [ZTools createLabelWithFrame:CGRectMake(20, 90, _winnerView.width-40, 20)
                                                       text:name
                                                  textColor:RGBCOLOR(251, 228, 75)
                                              textAlignment:NSTextAlignmentCenter
                                                       font:15];
    [_winnerView addSubview:prizeNameLabel];
    
    /*
    userNameLabel = [ZTools createLabelWithFrame:CGRectMake(40, 200, _winnerView.width-80, 20)
                                                      text:@""
                                                 textColor:DEFAULT_GRAY_TEXT_COLOR
                                             textAlignment:NSTextAlignmentLeft
                                                      font:13];
    [_winnerView addSubview:userNameLabel];
    
    
    addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, userNameLabel.bottom+5, _winnerView.width-60, 60)];
    addressTextView.editable = NO;
    addressTextView.textColor = DEFAULT_GRAY_TEXT_COLOR;
    addressTextView.font = [ZTools returnaFontWith:13];
    addressTextView.textAlignment = NSTextAlignmentLeft;
    addressTextView.showsVerticalScrollIndicator = NO;
    addressTextView.text = @"";
    addressTextView.backgroundColor = [UIColor whiteColor];
    [_winnerView addSubview:addressTextView];
    
    doneButton = [ZTools createButtonWithFrame:CGRectMake(_winnerView.width-130, _winnerView.height-60, 90, 25)
                                         title:@"立即兑换"
                                         image:nil];
    doneButton.titleLabel.font = [ZTools returnaFontWith:13];
    [doneButton addTarget:self action:@selector(convertByNow:) forControlEvents:UIControlEventTouchUpInside];
    [_winnerView addSubview:doneButton];
    
    if (isVirtual) {
        addressTextView.text = @"宝贝信息将以短信形式发送到您手机上，请注意查收。您也可以到个人中心的“夺宝历史”查看宝贝状态";
        userNameLabel.text = [NSString stringWithFormat:@"手机号码:%@",[ZTools getPhoneNum]];
        doneButton.center = CGPointMake(_winnerView.width/2.0f, doneButton.center.y);
    } else {
        //管理收货地址
        UserAddressModel * address = [ZTools getAddressModel];
        [self setupAddressWithAddressModel:address];
    }
    */
    [self createAddressConfirmWithTop:200 target:_winnerView isVirtual:isVirtual convert:NO];
    [ZTools cureInAnimationWithView:_winnerView];
}
#pragma mark -------  未中奖视图
-(void)showFailedViewWithBackTap:(void (^)(void))back{
    [_lotteryImageView.layer removeAllAnimations];
    [_lotteryImageView removeFromSuperview];
    _lotteryImageView = nil;
    
    [self addSubview:self.failedView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake((_failedView.width-120)/2.0, 280, 120, 35);
    [backButton setImage:[UIImage imageNamed:@"lottery_back_image"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.failedView addSubview:backButton];
    
    [ZTools cureInAnimationWithView:_failedView];
}
#pragma mark ------  夺宝历史->立即兑换视图
-(void)showConertViewWithVirtual:(BOOL)isVirtual
                      convertBlock:(LotteryViewConvertBlock)cBlock
                       modifyBlock:(LotteryViewModifyAddressBlock)mBlock {
    convertBlock = cBlock;
    modifyBlock = mBlock;
    
    [self addSubview:self.convertView];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(self.convertView.width-56, 0, 56, 20);
    [closeButton setImage:[UIImage imageNamed:@"prize_convert_close_image"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.convertView addSubview:closeButton];
    
    [self createAddressConfirmWithTop:70 target:self.convertView isVirtual:isVirtual convert:YES];
    
    [ZTools cureInAnimationWithView:self.convertView];
}

-(void)createAddressConfirmWithTop:(float)top target:(UIView *)view isVirtual:(BOOL)isVirtual convert:(BOOL)isConvert{
    
    userNameLabel = [ZTools createLabelWithFrame:CGRectMake(isConvert?20:40, top, view.width-(isConvert?40:80), 20)
                                            text:@""
                                       textColor:DEFAULT_GRAY_TEXT_COLOR
                                   textAlignment:NSTextAlignmentLeft
                                            font:13];
    [view addSubview:userNameLabel];
    
    addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(isConvert?15:30, userNameLabel.bottom+5, view.width-(isConvert?30:60), 60)];
    addressTextView.editable = NO;
    addressTextView.textColor = DEFAULT_GRAY_TEXT_COLOR;
    addressTextView.font = [ZTools returnaFontWith:13];
    addressTextView.textAlignment = NSTextAlignmentLeft;
    addressTextView.showsVerticalScrollIndicator = NO;
    addressTextView.text = @"";
    addressTextView.backgroundColor = [UIColor whiteColor];
    [view addSubview:addressTextView];
    
    doneButton = [ZTools createButtonWithFrame:CGRectMake(view.width-90-(isConvert?20:40), addressTextView.bottom+10, 90, 25)
                                         title:@"立即兑换"
                                         image:nil];
    doneButton.titleLabel.font = [ZTools returnaFontWith:13];
    [doneButton addTarget:self action:@selector(convertByNow:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneButton];
    
    if (isVirtual) {
        addressTextView.text = @"宝贝信息将以短信形式发送到您手机上，请注意查收。您也可以到个人中心的“夺宝历史”查看宝贝状态";
        userNameLabel.text = [NSString stringWithFormat:@"手机号码:%@",[ZTools getPhoneNum]];
        doneButton.center = CGPointMake(view.width/2.0f, doneButton.center.y);
    } else {
        //管理收货地址
        UserAddressModel * address = [ZTools getAddressModel];
        [self setupAddressWithAddressModel:address];
    }
}

#pragma mark ------  返回按钮
-(void)backButtonClicked:(UIButton *)button{
    [self removeFromSuperview];
}

#pragma mark ----  立即兑换
-(void)convertByNow:(UIButton *)button{
    
    if ([button.titleLabel.text isEqualToString:@"添加收货地址"]) {
        if (modifyBlock) {
            modifyBlock();
        }
    } else {
        if (convertBlock) {
            convertBlock();
        }
        [self removeFromSuperview];
    }
}
#pragma mark ----  修改收货地址
-(void)modifyAddress:(UIButton *)button{
    if (modifyBlock) {
        modifyBlock();
    }
}

#pragma mark - 抖动动画
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
- (void)shakingAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(Angle2Radian(-5)), @(Angle2Radian(5)), @(Angle2Radian(-5))];
    anim.duration = 0.15;
    
    // 动画次数设置为最大
    anim.repeatCount = MAXFLOAT;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [_lotteryImageView.layer addAnimation:anim forKey:@"shake"];
}


#pragma mark ------  设置收货地址
-(void)setupAddressWithAddressModel:(UserAddressModel *)address{
    
    BOOL isConvert = _convertView;
    
    UIView * view = nil;
    if (_winnerView && !_convertView) {
        view = self.winnerView;
    }else if (_convertView && !_winnerView) {
        view = self.convertView;
    }else {
        return;
    }
    
    if (address)
    {
        if (!modifyAddressButton) {
            modifyAddressButton = [ZTools createButtonWithFrame:CGRectZero
                                                          title:@"修改地址"
                                                          image:nil];
            modifyAddressButton.titleLabel.font = [ZTools returnaFontWith:13];
            [modifyAddressButton addTarget:self action:@selector(modifyAddress:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        modifyAddressButton.frame = CGRectMake(isConvert?20:40, doneButton.top, 90, 25);
        [view addSubview:modifyAddressButton];
        
        addressTextView.text = [NSString stringWithFormat:@"%@%@",address.user_city,address.user_area];
        userNameLabel.text = [NSString stringWithFormat:@"%@(%@)",address.put_man,[ZTools getPhoneNum]];
        
        if ([doneButton.titleLabel.text isEqualToString:@"添加收货地址"]) {
            [doneButton setTitle:@"立即兑换" forState:UIControlStateNormal];
            doneButton.left = view.width - 90 - (isConvert?20:40);
        }
    }else
    {
        userNameLabel.text = @"请先添加收货信息";
        doneButton.centerX = view.width/2.0f;
        [doneButton setTitle:@"添加收货地址" forState:UIControlStateNormal];
    }
}


-(void)dealloc{
    [_failedView removeFromSuperview];
    _failedView = nil;
    [_winnerView removeFromSuperview];
    _winnerView = nil;
    [_lotteryImageView removeFromSuperview];
    _lotteryImageView = nil;
    
    convertBlock = nil;
    modifyBlock = nil;
}

@end






