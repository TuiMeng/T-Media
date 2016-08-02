//
//  SShareView.m
//  推盟
//
//  Created by joinus on 15/8/27.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "SShareView.h"


@interface SShareView (){
    NSArray * title_array;
}
@property(nonatomic,strong)UIView * touchView;
@property(nonatomic,strong)UIViewController * presentedController;
@property(nonatomic,strong)NSString * share_content;
@property(nonatomic,strong)UIImage * share_image;
@property(nonatomic,strong)CLLocation * share_location;
@property(nonatomic,strong)UMSocialUrlResource * share_urlResource;
@property(nonatomic,strong)NSString * share_url;
@property(nonatomic,strong)NSString * share_title;

@end


@implementation SShareView

-(id)initWithTitles:(NSArray *)array
              title:(NSString*)title
            content:(NSString *)content
                Url:(NSString *)url
              image:(UIImage*)image
           location:(CLLocation *)location
        urlResource:(UMSocialUrlResource *)urlResource
    presentedController:(UIViewController *)presentedController{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        title_array = array;
        _presentedController = presentedController;
        _share_content = content;
        _share_image = image;
        _share_location = location;
        _share_urlResource = urlResource;
        _share_url = url;
        _share_title = title;
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        
        self.touchView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        self.touchView.hidden=YES;
        self.touchView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.frame=CGRectMake(0, self.touchView.frame.size.height, DEVICE_WIDTH, 268 + 7);
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareviewHiden:)];
        [self.touchView addGestureRecognizer:tap];
        [self.touchView addSubview:self];
        [self createContentViewWithTitle:array];
    }
    return self;
}

-(id)initWithSNSArray:(NSArray*)array{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        
        self.touchView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        self.touchView.hidden=YES;
        self.touchView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.frame=CGRectMake(0, self.touchView.frame.size.height, DEVICE_WIDTH, 268 + 7);
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareviewHiden:)];
        [self.touchView addGestureRecognizer:tap];
        [self.touchView addSubview:self];
        [self createContentViewWithTitle:array];
    }
    
    return self;
}


-(void)createContentViewWithTitle:(NSArray *)array{
    
    float image_width = [ZTools autoWidthWith:60];
    float space = (DEVICE_WIDTH-(image_width*4))/5;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString * title = array[i];
        
        CGRect frame = CGRectMake(space+(space+image_width)*(i%4), 20 + (image_width+50)*(i/4), image_width, image_width);
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(shareButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        
        UIImage * image = nil;
        if ([title isEqualToString:SHARE_WECHAT_FRIEND]) {
            image = [UIImage imageNamed:@"share_wechat_image"];
        }else  if ([title isEqualToString:SHARE_WECHAT_CIRCLE]) {
            image = [UIImage imageNamed:@"share_wechat_circle_image"];
        }else  if ([title isEqualToString:SHARE_SINA_WEIBO]) {
            image = [UIImage imageNamed:@"share_weibo"];
        }else  if ([title isEqualToString:SHARE_TENTCENT_QQ]) {
            image = [UIImage imageNamed:@"share_tentcent_qq_image"];
        }else  if ([title isEqualToString:SHARE_COPY]) {
            image = [UIImage imageNamed:@"share_copy_image"];
        }else  if ([title isEqualToString:SHARE_QZONE]) {
            image = [UIImage imageNamed:@"share_qzone_image"];
        }else  if ([title isEqualToString:SHARE_DOUBAN]) {
            image = [UIImage imageNamed:@"share_douban_image"];
        }
        
        [button setImage:image forState:UIControlStateNormal];
        
        if (i == array.count-1) {
            self.height = button.bottom + 110;
        }
        
        UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(button.left - (space-10)/2, button.bottom + 10, button.width+(space-10), 25)];
        title_label.text = title;
        title_label.font = [ZTools returnaFontWith:12];
        title_label.textColor = RGBCOLOR(55, 55, 55);
        title_label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title_label];
    }
    
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-50, DEVICE_WIDTH, 0.5)];
    line_view.backgroundColor = DEFAULT_LINE_COLOR;
    [self addSubview:line_view];
    
    UIButton * cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel_button.frame = CGRectMake(20,self.height-50, self.width-40, 50);
    [cancel_button setTitle:@"取消" forState:UIControlStateNormal];
    cancel_button.titleLabel.font = [ZTools returnaFontWith:18];
    [cancel_button setTitleColor:RGBCOLOR(42, 42, 42) forState:UIControlStateNormal];
    [cancel_button addTarget:self action:@selector(cancelButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel_button];
}

-(void)shareButtonTap:(UIButton*)sender{
    NSString * share_type = @"";
    NSString * title = title_array[sender.tag-100];
    NSString * snsName = @"";
    if ([title isEqualToString:SHARE_WECHAT_FRIEND]) {
        share_type = @"微信好友";
        snsName = @"wxsession";
         [UMSocialData defaultData].extConfig.wechatSessionData.url = _share_url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = _share_title;
        
//        [UMSocialData defaultData].urlResource = _share_urlResource;
        
    }else  if ([title isEqualToString:SHARE_WECHAT_CIRCLE]) {
        share_type = @"微信朋友圈";
        snsName = @"wxtimeline";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _share_url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = _share_title;

    }else  if ([title isEqualToString:SHARE_SINA_WEIBO]) {
        share_type = @"新浪";
        snsName = @"sina";
        _share_content = [NSString stringWithFormat:@"%@%@",_share_content,_share_url];

    }else  if ([title isEqualToString:SHARE_TENTCENT_QQ]) {
        share_type = @"qq";
        snsName = @"qq";
        [UMSocialData defaultData].extConfig.qqData.url = _share_url;
        [UMSocialData defaultData].extConfig.qqData.title = _share_title;

    }else if ([title isEqualToString:SHARE_QZONE]){
        share_type = @"qzone";
        snsName = UMShareToQzone;
        [UMSocialData defaultData].extConfig.qzoneData.url = _share_url;
        [UMSocialData defaultData].extConfig.qzoneData.title = _share_title;
        
    }else if ([title isEqualToString:SHARE_DOUBAN]){
        share_type = @"豆瓣";
        snsName = UMShareToDouban;
        
        _share_content = [NSString stringWithFormat:@"%@ %@",_share_content,_share_url];
        
    }else  if ([title isEqualToString:SHARE_COPY]) {
        UIPasteboard * paste = [UIPasteboard generalPasteboard];
        paste.string = self.string_copy;
        [ZTools showMBProgressWithText:@"复制成功" WihtType:MBProgressHUDModeText addToView:_presentedController.view isAutoHidden:YES];
        [self shareviewHiden:nil];
    }
    
    
    if (share_button_clicked_block) {
        share_button_clicked_block(snsName,share_type);
    }
    
    /*
    
    if (snsName.length > 0) {
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:_share_content image:_share_image location:_share_location urlResource:_share_urlResource presentedController:_presentedController completion:^(UMSocialResponseEntity * response)
         {
             if (response.responseCode == UMSResponseCodeSuccess)
             {
                 if (share_success_block) {
                     share_success_block(share_type);
                 }
             } else if(response.responseCode != UMSResponseCodeCancel) {
                 if (share_failed_block) {
                     share_failed_block();
                 }
             }
         }];
    }
    
    */
}

-(void)shareWithSNS:(NSString *)snsName WithShareType:(NSString *)type{
    
    if (snsName.length > 0) {
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName]
                                                           content:_share_content
                                                             image:_share_image
                                                          location:_share_location
                                                       urlResource:_share_urlResource
                                               presentedController:_presentedController
                                                        completion:^(UMSocialResponseEntity * response)
         {
             if (response.responseCode == UMSResponseCodeSuccess)
             {
                 if (share_success_block) {
                     share_success_block(type);
                 }
             } else if(response.responseCode != UMSResponseCodeCancel) {
                 if (share_failed_block) {
                     share_failed_block();
                 }
             }else{
                 share_failed_block();
             }
         }];
    }

}
//为新浪微博140字符限制提供的自定义分享标题
-(void)shareWithSNS:(NSString *)snsName WithShareType:(NSString *)type title:(NSString *)title{
    
    if (snsName.length > 0) {
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName]
                                                           content:title
                                                             image:_share_image
                                                          location:_share_location
                                                       urlResource:_share_urlResource
                                               presentedController:_presentedController
                                                        completion:^(UMSocialResponseEntity * response)
         {
             if (response.responseCode == UMSResponseCodeSuccess)
             {
                 if (share_success_block) {
                     share_success_block(type);
                 }
             } else if(response.responseCode != UMSResponseCodeCancel) {
                 if (share_failed_block) {
                     share_failed_block();
                 }
             }else{
                 share_failed_block();
             }
         }];
    }
    
}


-(void)shareButtonClicked:(SShareViewButtonClickedBlock)block{
    share_button_clicked_block = block;
}

-(void)setShareSuccess:(SShareViewSuccessBlock)sblock failed:(SShareViewFailedBlock)fblock{
    share_success_block = sblock;
    share_failed_block = fblock;
}

-(void)cancelButtonTap:(UIButton*)sender{
    [self shareviewHiden:nil];
}

-(void)showInView:(UIView *)view{
    [view addSubview:self.touchView];
    self.touchView.hidden = NO;
    
    [UIView animateWithDuration:0.4f animations:^{
        self.top = self.touchView.height - self.height;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)ShareViewRemoveFromSuperview{
    self.touchView.hidden = YES;
}
-(void)shareviewHiden:(UITapGestureRecognizer*)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, self.touchView.frame.size.height, DEVICE_WIDTH, 268);
    } completion:^(BOOL finished) {
        self.touchView.hidden=YES;
    }];
}

@end
