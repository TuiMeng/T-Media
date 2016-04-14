//
//  SYearPickerView.m
//  推盟
//
//  Created by joinus on 15/8/31.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "SYearPickerView.h"

@implementation SYearPickerView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

-(void)setMinimumYear:(NSNumber *)minimumYear
{
    _minimumYear = minimumYear;
    [self reloadAllComponents];
}

-(void)setMaximumYear:(NSNumber *)maximumYear
{
    _maximumYear = maximumYear;
    [self reloadAllComponents];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (syear_picker_view_block) {
        syear_picker_view_block([NSString stringWithFormat:@"%d",_minimumYear.intValue+(int)row],(int)row);
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _maximumYear.intValue - _minimumYear.intValue;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d",_minimumYear.intValue+(int)row];
}

-(void)didSelectedRow:(SYearPickerViewBlock)block{
    syear_picker_view_block = block;
}


@end
