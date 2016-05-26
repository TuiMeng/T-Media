//
//  LogInView.h
//  推盟
//
//  Created by joinus on 16/5/18.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  登录视图
 */

#import <UIKit/UIKit.h>

typedef void(^LoginViewSuccessBlock)(void);


@interface LogInView : UIView{
    LoginViewSuccessBlock successBlock;
}



+(instancetype)sharedInstance;



-(void)loginShowWithSuccess:(LoginViewSuccessBlock)success;








@end
