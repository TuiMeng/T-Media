//
//  LogInViewController.h
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/*
 **登陆
 */

#import <UIKit/UIKit.h>

typedef void(^LoginSuccessBlock)(NSString*source);

@interface LogInViewController : MyViewController{
    LoginSuccessBlock login_block;
}

/**
 *  来源
 */
@property(nonatomic,strong)NSString * source_type;

+ (LogInViewController *)sharedManager;

-(void)successLogin:(LoginSuccessBlock)block;

@end
