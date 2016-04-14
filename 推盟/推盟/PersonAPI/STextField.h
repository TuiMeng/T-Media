//
//  STextField.h
//  推盟
//
//  Created by joinus on 15/8/20.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTFIELD_HEIGHT 40

@interface STextField : UITextField{
    UIImageView * imageView;
}


@property(nonatomic,strong)UIImage * left_image;
/**
 *  缩进  默认缩进20像素
 */
@property(nonatomic,assign)float indent;

@end
