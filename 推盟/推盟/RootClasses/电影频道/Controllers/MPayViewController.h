//
//  MPayViewController.h
//  推盟
//
//  Created by joinus on 16/3/17.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  支付
 */

#import "MyViewController.h"
#import "MCardPayViewController.h"
#import "MovieListModel.h"
#import "MLocationCinemasModel.h"
#import "MovieSequencesModel.h"

@interface MPayViewController : MyViewController


@property(nonatomic,assign)int                      countDown;
@property(nonatomic,strong)MovieListModel           * movie_model;
@property(nonatomic,strong)MLocationCinemasModel    * cinema_model;
@property(nonatomic,strong)MovieSequencesModel      * sequenceModel;
//选取座位数
@property(nonatomic,assign)int                      seatCount;

@property(nonatomic,strong)NSString                 * orderId;
//积分抵消费用
@property(nonatomic,assign)int                      scorePrice;
//全部服务费用
@property(nonatomic,assign)float                    serverPrice;
//总共需要支付的费用
@property(nonatomic,assign)float                    totalPrice;


@end
