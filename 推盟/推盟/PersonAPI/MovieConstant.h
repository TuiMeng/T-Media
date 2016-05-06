//
//  MovieConstant.h
//  推盟
//
//  Created by joinus on 16/3/23.
//  Copyright © 2016年 joinus. All rights reserved.
//

#ifndef MovieConstant_h
#define MovieConstant_h

#define MOVIE_ERROR_CODE @"result"
#define MOVIE_ERROR_INFO @"message"

#pragma mark  *****************颜色********************
//星星颜色
#define STAR_FILL_COLOR RGBCOLOR(253, 180, 90)
#define STAR_UNFILL_COLOR RGBCOLOR(205, 204, 209)
#define STAR_STROKE_COLOR RGBCOLOR(253, 180, 90)

#define DEFAULT_ORANGE_TEXT_COLOR RGBCOLOR(245,146,44)
#define DEFAULT_RED_TEXT_COLOR RGBCOLOR(210,54,55)
#define DEFAULT_GRAY_TEXT_COLOR RGBCOLOR(127,127,127)
#define DEFAULT_BLACK_TEXT_COLOR RGBCOLOR(31,31,31)
#define DEFAULT_MOVIE_LINE_COLOR RGBCOLOR(204,204,204)



#pragma **********************  接口相关 **********************
#define BASE_M_URL @"http://test.twttmob.com/test_version.php"
//添加购票订单
//http://localhost:8080/pwmobile/mobile/ lockseats?bid=100001&planid=99920130502054461& orderid=10001&seatids=1:01_
//#define M_ADD_MOVIE_ORDER [NSString stringWithFormat:@"%@/pwmobile/mobile/lockseats?",BASE_MOVIE_URL]

//添加购票订单
#define MOVIE_ADD_MOVIE_ORDER       [NSString stringWithFormat:@"%@?m=Apply&a=e_point_order1",BASE_M_URL]
//支付接口
#define MOVIE_PAY_ORDER_URL         [NSString stringWithFormat:@"%@?m=Apply&a=e_point_order2",BASE_M_URL]
//检测订单支付信息
#define MOVIE_CHECK_PAY_INFO_URL    [NSString stringWithFormat:@"%@?m=Pay&a=wx_order",BASE_M_URL]
//解锁座位信息
#define MOVIE_RELEASE_SEAT_URL      [NSString stringWithFormat:@"%@?m=Pay&a=unlock",BASE_M_URL]
//查看订单列表
#define MOVIE_ORDER_LIST_URL        [NSString stringWithFormat:@"%@?m=Task&a=getMovieOrderList",BASE_M_URL]
//重新发送取票码接口
#define MOVIE_SEND_TICKERCODE_URL   [NSString stringWithFormat:@"%@?m=Gift&a=renote",BASE_M_URL]



#endif /* MovieConstant_h */
