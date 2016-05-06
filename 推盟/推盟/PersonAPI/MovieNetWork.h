//
//  MovieNetWork.h
//  推盟
//
//  Created by joinus on 16/4/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

#define NOTIFICATION_TIME_STRING @"movieOrderTimeChange"

typedef void(^movieOrderTimerBlock)(int count,NSTimer * time);

@interface MovieNetWork : BaseModel{
    NSOperationQueue        * queue;
    movieOrderTimerBlock    timerBlock;
    NSTimer                 * timer;
    int      totalCount;
}
/**
 *  订单计时器
 */
@property(nonatomic,strong)NSTimer  * orderTimer;

+ (MovieNetWork *)sharedManager;
/**
 *  解锁座位
 */
-(void)releaseMovieSeatsWithOrderId:(NSString *)orderId;
/**
 *  查询城市id
 */
-(void)checkCityIdWitCityName:(NSString *)name success:(void(^)(NSString * id))success failure:(void(^)(NSString *error))failure;
/**
 *  增加计时器
 *
 *  @param interval 时间间隔
 *  @param repeats  是否重复
 *  @param count    总时间
 *  @param block    block
 */
-(void)orderTimerStartTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats TotalCount:(int)count timer:(movieOrderTimerBlock)block;

-(void)endTimer;

@end
