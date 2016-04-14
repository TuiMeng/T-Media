//
//  STextView.m
//  推盟
//
//  Created by joinus on 16/3/8.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "STextView.h"


@interface STextView ()<UITextViewDelegate>{
    
}

@property(nonatomic,strong)UILabel * placeHolderLabel;


@end

@implementation STextView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlaceHolderLabel];
    }
    return self;
}

-(void)setPlaceHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placeHolderLabel.textColor = [UIColor blackColor];
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        [self addSubview:_placeHolderLabel];
    }
}

-(void)setFont:(UIFont *)font{
    _placeHolderLabel.font = font;
}

-(void)setPlaceHoder:(NSString *)placeHoder{
    _placeHoder = placeHoder;
    _placeHolderLabel.text = placeHoder;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = _placeHoder;
    }else{
        _placeHolderLabel.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



@end






















