//
//  MovieTools.m
//  推盟
//
//  Created by joinus on 16/3/9.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieTools.h"

@implementation MovieTools



+(NSString *)returnStateWithScore:(int)score{
    NSString * str = @"";
    if (score == 1 || score == 2) {
        str = @"超烂啊";
    }else if (score == 3 || score == 4){
        str = @"比较差";
    }else if (score == 5 || score == 6){
        str = @"一般般";
    }else if (score == 7 || score == 8){
        str = @"比较好";
    }else if (score == 9){
        str = @"棒极了";
    }else if (score == 10){
        str = @"完美";
    }
    
    return str;
}

#pragma mark ------  返回天数数组
+(NSMutableArray *)returnThreeDaysArray{
    NSString * today    = [NSString stringWithFormat:@"今天%@",[ZTools timechangeWithDate:[NSDate date] WithFormat:@"MM月dd日"]];
    NSString * nextDay  = [NSString stringWithFormat:@"明天%@",[ZTools timechangeWithDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60] WithFormat:@"MM月dd日"]];
    NSString * thirdDay = [NSString stringWithFormat:@"后天%@",[ZTools timechangeWithDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60*2] WithFormat:@"MM月dd日"]];
    return [NSMutableArray arrayWithObjects:today,nextDay,thirdDay,nil];
}

+(NSString *)getEndTimeWithStartTime:(NSString *)startTime WithDur:(int)dur{
    NSArray * array = [startTime componentsSeparatedByString:@":"];
    if (array.count == 2) {
        int hour    = [array[0] intValue] + dur/60;
        int min     = [array[1] intValue] + dur%60;
        
        if (min >= 60) {
            hour += 1;
            min = min%60;
        }
        
        if (hour >= 24) {
            hour = hour/24;
        }
        
        return [NSString stringWithFormat:@"%02d:%02d",hour,min];
        
    }else{
        return @"";
    }
}



@end
