//
//  SView.h
//  推盟
//
//  Created by joinus on 16/3/17.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SView : UIView

/**
 *  是否显示上划线
 */
@property(nonatomic,assign)BOOL isShowTopLine;
/**
 *  是否显示下划线
 */
@property(nonatomic,assign)BOOL isShowBottomLine;
/**
 *  是否显示左划线
 */
@property(nonatomic,assign)BOOL isShowLeftLine;
/**
 *  是否显示右划线
 */
@property(nonatomic,assign)BOOL isShowRightLine;
/**
 *  上划线
 */
@property(nonatomic,strong)UIView * topLine;
/**
 *  上划线
 */
@property(nonatomic,strong)UIView * bottomLine;
/**
 *  上划线
 */
@property(nonatomic,strong)UIView * leftLine;
/**
 *  上划线
 */
@property(nonatomic,strong)UIView * rightLine;

@property(nonatomic,strong)UIColor * lineColor;

@end
