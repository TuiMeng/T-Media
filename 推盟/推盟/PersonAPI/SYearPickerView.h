//
//  SYearPickerView.h
//  推盟
//
//  Created by joinus on 15/8/31.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SYearPickerViewBlock)(NSString*title,int index);



@interface SYearPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>{
    SYearPickerViewBlock syear_picker_view_block;
}


/// The minimum year that a month picker can show.
@property (nonatomic, strong) NSNumber* minimumYear;

/// The maximum year that a month picker can show.
@property (nonatomic, strong) NSNumber* maximumYear;


-(void)didSelectedRow:(SYearPickerViewBlock)block;



@end
