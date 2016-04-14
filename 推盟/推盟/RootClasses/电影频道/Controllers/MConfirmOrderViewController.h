//
//  MConfirmOrderViewController.h
//  推盟
//
//  Created by joinus on 16/3/16.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  确认订单
 */

#import "MyViewController.h"
#import "MovieSequencesModel.h"
#import "MLocationCinemasModel.h"
#import "MovieListModel.h"
#import "SeatModel.h"


@interface MConfirmOrderViewController : MyViewController


@property(nonatomic,strong)MovieSequencesModel      * sequenceModel;
@property(nonatomic,strong)MLocationCinemasModel    * cinema_model;
@property(nonatomic,strong)MovieListModel           * movie_model;
@property(nonatomic,strong)NSMutableArray           * seatArray;
//订单号
@property(nonatomic,strong)NSString                 * orderId;

@end
