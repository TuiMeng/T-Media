//
//  STextField.m
//  推盟
//
//  Created by joinus on 15/8/20.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "STextField.h"

@implementation STextField

-(void)awakeFromNib{
    self.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)addLeftImage{
    imageView = [[UIImageView alloc] initWithImage:_left_image];
    imageView.center = CGPointMake(_left_image.size.width/2+15,TEXTFIELD_HEIGHT/2.0);
    [self addSubview:imageView];
}

-(void)setLeft_image:(UIImage *)left_image{
    _left_image = left_image;
    [self addLeftImage];
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(_indent?_indent:20,bounds.origin.y,bounds.size.width-(_indent?_indent:20),bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(_indent?_indent:20,bounds.origin.y,bounds.size.width-(_indent?_indent:20),bounds.size.height);
}



@end
