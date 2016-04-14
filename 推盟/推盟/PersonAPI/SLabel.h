//
//  SLabel.h
//  推盟
//
//  Created by joinus on 15/8/21.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface SLabel : UILabel{
@private
    VerticalAlignment verticalAlignment_;

}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

-(id)initWithFrame:(CGRect)frame WithVerticalAlignment:(VerticalAlignment)alignment;

@end
