//
//  SView.m
//  推盟
//
//  Created by joinus on 16/3/17.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "SView.h"

@implementation SView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)setIsShowTopLine:(BOOL)isShowTopLine{
    [self setupTopLine];
}

-(void)setIsShowBottomLine:(BOOL)isShowBottomLine{
    [self setupBottomLine];
}

-(void)setIsShowLeftLine:(BOOL)isShowLeftLine{
    [self setupleftLine];
}
-(void)setIsShowRightLine:(BOOL)isShowRightLine{
    [self setupRightLine];
}

-(void)setupleftLine{
    if (!_leftLine) {
        _leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.height)];
        _leftLine.backgroundColor = _lineColor;
        [self addSubview:_leftLine];
    }
}
-(void)setupTopLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _topLine.backgroundColor = _lineColor;
        [self addSubview:_topLine];
    }
}
-(void)setupRightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.width-0.5, 0, 0.5, self.height)];
        _rightLine.backgroundColor = _lineColor;
        [self addSubview:_rightLine];
    }
}
-(void)setupBottomLine{
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        _bottomLine.backgroundColor = _lineColor;
        [self addSubview:_bottomLine];
    }
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    if (_leftLine) {
        _leftLine.backgroundColor = lineColor;
    }
    if (_rightLine) {
        _rightLine.backgroundColor = lineColor;
    }
    if (_topLine) {
        _topLine.backgroundColor = lineColor;
    }
    if (_bottomLine) {
        _bottomLine.backgroundColor = lineColor;
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _rightLine.right = self.width;
    _bottomLine.bottom = self.height;
}

@end
