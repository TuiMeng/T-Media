//
//  GiftListCell.h
//  推盟
//
//  Created by joinus on 15/8/17.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftListModel.h"

typedef void(^GiftListLeftTapBlock)(void);
typedef void(^GiftListRightTapBlock)(void);

@interface GiftListCell : UITableViewCell{
    GiftListLeftTapBlock left_block;
    GiftListRightTapBlock right_block;
}

-(void)setGiftOneWith:(GiftListModel *)model1 TwoWith:(GiftListModel*)model2;

-(void)leftClicked:(GiftListLeftTapBlock)l_block rightClicked:(GiftListRightTapBlock)r_block;

@end
