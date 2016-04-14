//
//  SShareView.h
//  推盟
//
//  Created by joinus on 15/8/27.
//  Copyright (c) 2015年 joinus. All rights reserved.
//
/**
 *  分享平台列表
 */

#import <UIKit/UIKit.h>
#import "UMSocialData.h"
#import <CoreLocation/CoreLocation.h>

#define SHARE_WECHAT_FRIEND @"微信"
#define SHARE_WECHAT_CIRCLE @"朋友圈"
#define SHARE_TENTCENT_QQ @"QQ好友"
#define SHARE_QZONE @"QQ空间"
#define SHARE_DOUBAN @"豆瓣网"
#define SHARE_SINA_WEIBO @"新浪"
#define SHARE_COPY @"复制邀请码"

typedef void(^SShareViewSuccessBlock)(NSString * type);
typedef void(^SShareViewFailedBlock)(void);
typedef void(^SShareViewButtonClickedBlock)(NSString*snsName,NSString*shareType);

@interface SShareView : UIView{
    SShareViewSuccessBlock share_success_block;
    SShareViewFailedBlock share_failed_block;
    SShareViewButtonClickedBlock share_button_clicked_block;
}
/**
 *  需要复制的字符串
 */
@property(nonatomic,strong)NSString * string_copy;

-(id)initWithTitles:(NSArray*)array
              title:(NSString*)title
           content:(NSString *)content
            Url:(NSString*)url
             image:(UIImage*)image
          location:(CLLocation *)location
       urlResource:(UMSocialUrlResource *)urlResource
presentedController:(UIViewController *)presentedController;


-(void)setShareSuccess:(SShareViewSuccessBlock)sblock failed:(SShareViewFailedBlock)fblock;
-(void)showInView:(UIView*)view;
-(void)ShareViewRemoveFromSuperview;
///点击某个平台分享按钮
-(void)shareButtonClicked:(SShareViewButtonClickedBlock)block;
///分享
-(void)shareWithSNS:(NSString*)snsName WithShareType:(NSString*)type;

@end
