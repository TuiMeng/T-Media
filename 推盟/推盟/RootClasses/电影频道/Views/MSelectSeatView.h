//
//  MSelectSeatView.h
//  推盟
//
//  Created by joinus on 16/3/10.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  选择座位
 */

#import <UIKit/UIKit.h>
#import "KyoCenterLineView.h"
#import "KyoCinameSeatScrollView.h"
#import "SeatModel.h"


typedef void(^MselectSeatDidSelectedBlock)(SeatModel * model);



@protocol SMCinameSeatScrollViewDelegate;

@interface MSelectSeatView : UIView{
    MselectSeatDidSelectedBlock selectedSeatBlock;
}

@property(nonatomic,strong)NSMutableArray * seatArray;
@property (weak, nonatomic) id<SMCinameSeatScrollViewDelegate> SMCinameSeatScrollViewDelegate;


-(id)initWithFrame:(CGRect)frame WithSeatArray:(NSMutableArray *)seats;

-(void)selectSeatClicked:(MselectSeatDidSelectedBlock)block;

-(void)deleteSeatWithSeatModel:(SeatModel *)model;

@end

@protocol SMCinameSeatScrollViewDelegate <NSObject>

@optional
- (KyoCinameSeatState)kyoCinameSeatScrollViewSeatStateWithRow:(NSUInteger)row withColumn:(NSUInteger)column;
- (void)kyoCinameSeatScrollViewDidTouchInSeatWithRow:(NSUInteger)row withColumn:(NSUInteger)column;



@end
