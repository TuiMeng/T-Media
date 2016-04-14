//
//  HobbyViewController.h
//  推盟
//
//  Created by joinus on 15/9/10.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/**
 *  兴趣标签
 */

#import <UIKit/UIKit.h>

typedef void(^HobbySelectedBlock)(NSMutableArray*array);

@interface HobbyViewController : MyViewController{
    HobbySelectedBlock hobby_block;
}

@property(nonatomic,strong)NSMutableArray * titles_array;

-(void)selectedBlock:(HobbySelectedBlock)block;

@end
