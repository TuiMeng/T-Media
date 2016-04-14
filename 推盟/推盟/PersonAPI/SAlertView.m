//
//  SAlertView.m
//  推盟
//
//  Created by joinus on 15/8/26.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "SAlertView.h"

@interface SAlertView (){
    UIView * bottom_line_view;
    UIView * top_line_view;
}
//标题
@property(nonatomic,strong)UILabel * title_label;
//取消按钮
@property(nonatomic,strong)UIButton * cancel_button;
//确认按钮
@property(nonatomic,strong)UIButton * done_button;



@end


@implementation SAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithTitle:(NSString *)title WithContentView:(UIView *)contentView WithCancelTitle:(NSString *)cancelTitle WithDoneTitle:(NSString *)doneTitle{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.window.windowLevel = UIWindowLevelStatusBar;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        _background_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30,0, DEVICE_WIDTH-60, contentView.height+105)];
        _background_imageView.userInteractionEnabled = YES;
        _background_imageView.backgroundColor = [UIColor whiteColor];
        _background_imageView.layer.cornerRadius = 8;
        _background_imageView.layer.masksToBounds = YES;
        _background_imageView.clipsToBounds = YES;
        _background_imageView.center = CGPointMake(DEVICE_WIDTH/2.0f, DEVICE_HEIGHT/2.0f);
        [self addSubview:_background_imageView];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [self addGestureRecognizer:tap];
        
        
        
        _title_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,_background_imageView.width-20,40)];
        _title_label.text = title;
        _title_label.textColor = RGBCOLOR(55, 55, 55);
        _title_label.font = [UIFont systemFontOfSize:15];
        _title_label.textAlignment = NSTextAlignmentCenter;
        [_background_imageView addSubview:_title_label];
        
        top_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _background_imageView.width, 0.5)];
        top_line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [_background_imageView addSubview:top_line_view];
        
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, _background_imageView.width, 0)];
        contentView.top = 50;
        contentView.left = 10;
        [_background_imageView addSubview:contentView];
        
        
        if (cancelTitle.length != 0 && doneTitle.length != 0) {
            _cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancel_button.frame = CGRectMake(0, _background_imageView.height-45, _background_imageView.width/2.0f, 45);
            [_cancel_button setTitle:cancelTitle forState:UIControlStateNormal];
            [_cancel_button addTarget:self action:@selector(cancelButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [_cancel_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_background_imageView addSubview:_cancel_button];
            UIView * left_line_view = [[UIView alloc] initWithFrame:CGRectMake(_cancel_button.width-0.5, 0, 0.5, _cancel_button.height)];
            left_line_view.backgroundColor = DEFAULT_LINE_COLOR;
            [_cancel_button addSubview:left_line_view];
            
            _done_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _done_button.frame = CGRectMake(_background_imageView.width/2.0f, _background_imageView.height-45, _background_imageView.width/2.0f, 45);
            [_done_button setTitle:doneTitle forState:UIControlStateNormal];
             [_done_button addTarget:self action:@selector(doneButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [_done_button setTitleColor:DEFAULT_BACKGROUND_COLOR forState:UIControlStateNormal];
            [_background_imageView addSubview:_done_button];
            
            
            bottom_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, _background_imageView.height-45, _background_imageView.width, 0.5)];
            bottom_line_view.backgroundColor = DEFAULT_LINE_COLOR;
            [_background_imageView addSubview:bottom_line_view];
            
        }else{
            _cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancel_button.frame = CGRectMake(_background_imageView.width/4.0f, _background_imageView.height-45, _background_imageView.width/2.0f, 35);
            [_cancel_button addTarget:self action:@selector(cancelButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [_cancel_button setTitle:cancelTitle.length?cancelTitle:doneTitle forState:UIControlStateNormal];
            _cancel_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
            _cancel_button.layer.cornerRadius = 5;
            [_background_imageView addSubview:_cancel_button];
            
        }
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];;
    
    return self;
}

-(void)setContentView:(UIView *)contentView{
    _contentView = contentView;
    [_background_imageView addSubview:_contentView];
    [self resetFrame];
}

-(void)resetFrame{
    _background_imageView.height = 105+_contentView.height;
    bottom_line_view.top = _background_imageView.height-45;
    _cancel_button.top = _background_imageView.height-45;
    _done_button.top = _background_imageView.height-45;
    _background_imageView.center = CGPointMake(DEVICE_WIDTH/2.0f, DEVICE_HEIGHT/2.0f);
}

-(void)setTitle:(NSString *)title{
    _title_label.text = title;
}

#pragma - 取消按钮
-(void)cancelButtonTap:(UIButton*)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [_delegate cancelButtonClicked:sender];
    }
    [self removeFromSuperview];
}
#pragma mark - 确认按钮
-(void)doneButtonTap:(UIButton*)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(doneButtonClicked:)]) {
        [_delegate doneButtonClicked:sender];
    }
}
-(void)setDelegate:(id<SAlertViewDelegate>)delegate{
    _delegate = delegate;
}
-(void)alertShow{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [_background_imageView.layer addAnimation:animation forKey:nil];
}

-(void)doTap:(UITapGestureRecognizer*)sender{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
