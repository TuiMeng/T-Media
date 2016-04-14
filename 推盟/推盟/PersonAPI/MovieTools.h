//
//  MovieTools.h
//  推盟
//
//  Created by joinus on 16/3/9.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieTools : NSObject


+(NSString*)returnStateWithScore:(int)score;

+(NSMutableArray *)returnThreeDaysArray;
/**
 *  返回散场时间
 *
 *  @param startTime 开始时间
 *  @param dur       时长
 *
 *  @return 散场时间
 */
+(NSString *)getEndTimeWithStartTime:(NSString *)startTime WithDur:(int)dur;



@end
