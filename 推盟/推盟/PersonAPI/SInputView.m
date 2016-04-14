//
//  SInputView.m
//  推盟
//
//  Created by joinus on 16/3/28.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "SInputView.h"

@implementation SInputView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor          = RGBCOLOR(212, 212, 212);
        self.isShowTopLine      = YES;
        self.isShowBottomLine   = YES;
        self.backgroundColor    = [UIColor whiteColor];
        [self createMainView];
    }
    
    return self;
}

-(void)createMainView{
    
    _sendButton           = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame                = CGRectMake(DEVICE_WIDTH-75, (self.height-33)/2.0f, 60, 33);
    _sendButton.layer.borderWidth    = 0.5;
    _sendButton.layer.borderColor    = RGBCOLOR(212, 212, 212).CGColor;
    _sendButton.layer.cornerRadius   = 5;
    _sendButton.clipsToBounds        = YES;
    _sendButton.titleLabel.font      = [ZTools returnaFontWith:15];
    [_sendButton setBackgroundImage:[ZTools imageWithColor:RGBCOLOR(247, 247, 247)] forState:UIControlStateDisabled];
    [_sendButton setBackgroundImage:[ZTools imageWithColor:RGBCOLOR(45, 214, 97)] forState:UIControlStateNormal];
    [_sendButton setTitleColor:DEFAULT_GRAY_TEXT_COLOR forState:UIControlStateDisabled];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.enabled              = NO;
    [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
    
    _textField                      = [[STextField alloc] initWithFrame:CGRectMake(15, (self.height-33)/2.0f, _sendButton.left-30, 33)];
    _textField.placeholder          = @"写回复...";
    _textField.font                 = [ZTools returnaFontWith:13];
    _textField.layer.borderColor    = RGBCOLOR(212, 212, 212).CGColor;
    _textField.layer.borderWidth    = 0.5;
    _textField.layer.cornerRadius   = 5;
    _textField.indent               = 10;
    [self addSubview:_textField];
}

-(void)setSendBlock:(SInputViewSendBlock)block{
    sendBlock = block;
}

#pragma mark ------  发送
-(void)sendButtonClicked:(UIButton *)button{
    sendBlock();
}

@end












