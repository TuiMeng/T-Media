//
//  AddressPickerView.h
//  推盟
//
//  Created by joinus on 16/6/13.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addressPickViewSelectedBlock)(NSString * area);

@interface AddressPickerView : UIView{
    addressPickViewSelectedBlock myBlock;
}

+(instancetype)sharedInstance;

-(void)selectedBlock:(addressPickViewSelectedBlock)block;

-(void)show;


-(void)hidden;




@end
