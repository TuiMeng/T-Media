//
//  KyoButton.h
//  推盟
//
//  Created by joinus on 16/3/11.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  座位按钮
 */

#import <UIKit/UIKit.h>
#import "KyoCinameSeatScrollView.h"


@interface KyoButton : UIButton


@property(nonatomic,assign)int row;

@property(nonatomic,assign)int column;

@property(nonatomic,assign)KyoCinameSeatState currentState;

@end
