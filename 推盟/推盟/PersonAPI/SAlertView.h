//
//  SAlertView.h
//  推盟
//
//  Created by joinus on 15/8/26.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAlertViewDelegate <NSObject>

@optional
-(void)cancelButtonClicked:(UIButton*)sender;
-(void)doneButtonClicked:(UIButton*)sender;

@end

@interface SAlertView : UIView
/**
 *  内容视图（宽度必须为当前主视图的宽度）
 */
@property(nonatomic,strong)UIView * contentView;
/**
 *  标题
 */
@property(nonatomic,strong)NSString * title;
//背景图
@property(nonatomic,strong)UIImageView * background_imageView;
@property(nonatomic,assign)id<SAlertViewDelegate>delegate;

-(id)initWithTitle:(NSString *)title WithContentView:(UIView *)contentView WithCancelTitle:(NSString *)cancelTitle WithDoneTitle:(NSString *)doneTitle;
-(void)alertShow;
@end
