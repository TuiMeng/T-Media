//
//  SeatModel.h
//  推盟
//
//  Created by joinus on 16/3/15.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface SeatModel : BaseModel


@property(nonatomic,strong)NSString * seatCode;

@property(nonatomic,strong)NSString * seatId;
//0-过道 1-不可售2-空位 3-已售 4-转让 
@property(nonatomic,strong)NSString * seatStatus;

@property(nonatomic,assign)NSInteger row;

@property(nonatomic,assign)NSInteger column;

@end
