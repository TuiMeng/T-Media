//
//  DefaultConstant.h
//  推盟
//
//  Created by soulnear on 14-8-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#ifndef ___DefaultConstant_h
#define ___DefaultConstant_h

#define ERROR_CODE @"status"
#define ERROR_INFO @"errorinfo"

//弱引用
#define __WeakSelf__ __weak typeof (self)


#define SPREAD_WECHAT_TYPE  @"wechat"
#define SPREAD_QQ_TYPE      @"qq"
#define SPREAD_SINA_TYPE    @"sina"
#define SPREAD_DOUBAN_TYPE  @"douban"

//友盟
#define UMENG_KEY           @"576b984d67e58e37ff003480"

//微信
#define WECHAT_APPKEY1       @"wx128448d79fed11e8"
#define WECHAT_SECRET       @"aef571e5088b4c5abb3c2d1ba67c0f3f"
#define WECHAT_MCHID        @"1357168702"
//商户API密钥，填写相应参数
//#define PARTNER_ID          @"34EE39AE4A5262A220781A78A1DC4F6D"
#define PARTNER_ID          @"CD9C0E5D043471BDCB16463EBCC1F122"
//微信分享
#define WECHAT_APPKEY       @"wx128448d79fed11e8"


//高德地图key（推盟）
#define AMAP_KEY            @"ad0d37a0dfa0cf927897e639a246af04"
//高德地图key（影迷乐）
#define YML_AMAP_KEY            @"f135a41c82e11c56494ab4d0efd25c3b"

//移动官网
#define WEBSITEH5 @"http://h5.twttmob.com/tuimengmobile/"
//积分夺宝地址
#define PRIZE_WEBSITEH5(taskId,userId) [NSString stringWithFormat:@"http://h5.twttmob.com/tuimengpages/jifenduobao/baobeixiangqing.html?task_id=%@&user_id=%@",taskId,userId]
//游戏中心地址
#define GAME_SITE(dateline) [NSString stringWithFormat:@"http://h5.twttmob.com/game2/index2.html?%@",dateline]

#pragma mark - 图片
#define NAVIGATION_IMAGE [UIImage imageNamed:@"navigation_image"]
#define BACKGROUND_IMAGE [UIImage imageName:@"background_image.jpg"]
//加载默认图图片
#define DEFAULT_LOADING_BIG_IMAGE @"default_loading_big_image"
#define DEFAULT_LOADING_SMALL_IMAGE @"default_loading_small_image"
//图形验证码loading图片
#define DEFAULT_VERIFY_LOADING_IMAGE @"vericationCodeLoadingImage"

#define CURRENT_BUILD   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define APP_NAME        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//判断该版本是影迷乐还是推盟
#define IS_YML          [APP_NAME isEqualToString:@"影迷乐"]

#pragma mark 所有接口
//#pragma mark -----------测试域名 start--------------
//#define WEBSITE @"http://tmtest.twttmob.com"
////测试地址
////推盟域名
//#define BASE_URL            @"http://tmtest.twttmob.com/test_version.php"
////首页任务txt文件地址
//#define TASK_TXT_URL(dateline) [NSString stringWithFormat:@"http://tmtest.twttmob.com/Test_version/include/index_lista.txt?%@",dateline]
////电影频道域名
//#define BASE_MOVIE_URL      @"http://202.108.31.66:8088/tmmobile/mobile/"
////微信回调测试地址
//#define WECHAT_CALLBACK_URL [NSString stringWithFormat:@"%@/Test_version/include/wxpay/xmkp_notify.php",WEBSITE]
//#pragma mark -----------------  图形验证码地址
//#define T_VERICATION_CODE_IMAGE_URL(dateline) [NSString stringWithFormat:@"http://tmtest.twttmob.com/Test_version/Tpl/Public/phpyzm/code_gg.php?%@",dateline]
//#pragma mark ****-----------测试域名 end--------------****


#pragma mark -----------正式域名 start--------------
//正式地址
#define WEBSITE @"http://api.twttmob.com"
//推盟域名
#define BASE_URL          @"http://api.twttmob.com/Api.php"
//首页任务txt文件地址(正式环境)
#define TASK_TXT_URL(dateline) [NSString stringWithFormat:@"http://api.twttmob.com/Api/include/index_lista.txt?%@",dateline]
//电影频道域名
#define  BASE_MOVIE_URL     @"http://www.yingmile.com/tmmobile/mobile/"
//微信回调正式地址
#define WECHAT_CALLBACK_URL [NSString stringWithFormat:@"%@/Api/include/wxpay/xmkp_notify.php",WEBSITE]
#pragma mark -----------------  图形验证码地址
#define T_VERICATION_CODE_IMAGE_URL(dateline) [NSString stringWithFormat:@"http://api.twttmob.com/Api/Tpl/Public/phpyzm/code_gg.php?%@",dateline]
#pragma mark ****----------正式域名 end--------------****


//电影频道图片地址域名
#define BASE_MOVIE_IMAGE_URL @"http://www.yingmile.com/yml_img"


#pragma mark --========== 新增接口 ===========
#pragma mark -------  首页 获取所有标签接口
#define ROOT_TITLES_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_column",BASE_URL]
#pragma mark --------  首页获取任务列表
//在线任务
#define GET_ALL_ONLINE_TASK_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_tasklist",BASE_URL]
//已结束任务（user_id：用户id column_id：栏目id type：类型<1：更新数据；2：加载更多> page：条数 task_endid：任务id）
#define GET_ALL_OFFLINE_TASK_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_tasklist_offline",BASE_URL]

#pragma mark -----  获取礼品兑换页/首页 焦点图
#define GIFT_FOCUS_IMAGES_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_index",BASE_URL]
#pragma mark -----  获取商品列表
#define GIFT_LIST_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_giftlist",BASE_URL]
#pragma mark -----  获取商品详情接口
#define GIFT_DETAIL_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_giftdetail",BASE_URL]
#pragma mark -----   申请礼品兑换接口
#define GIFT_APPLY_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_getgift",BASE_URL]
#pragma mark -------- 礼品兑换记录接口
#define GIFT_RECORD_LIST [NSString stringWithFormat:@"%@?m=Gift&a=e_point_giftrecordlist",BASE_URL]
#pragma mark --------  申请礼品兑换获取验证码接口
#define GET_APPLY_VERIFICATION_GIFT_URL [NSString stringWithFormat:@"%@?m=Gift&a=dx_getlist",BASE_URL]


#pragma mark -------- 提现记录接口
#define APPLY_LIST_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_applylist",BASE_URL]
#pragma mark --------  申请提现获取验证码接口
#define GET_APPLY_VERIFICATION_CODE_URL [NSString stringWithFormat:@"%@?m=Gift&a=reflect",BASE_URL]



#pragma mark -----------------  排行榜
#define RANGKING_LIST_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_rankinglist",BASE_URL]

#pragma mark  --------------   邀请好友列表接口   --------------------
#define INVITATION_LIST_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_invitation",BASE_URL]

#pragma mark ———————————————— 提现说明  ——————————————————————
#define APPLY_INTRODUCTION_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_applyintroduction",BASE_URL]

#pragma mark ---------------    修改密码接口    ——————————————————————————
#define MODIFY_PASSWORD_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_modifypassworld",BASE_URL]
#pragma mark ————————————————————  修改用户信息  ——————————————————————————————
#define MODIFY_USER_INFOMATION_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_modifyinfomation",BASE_URL]
#pragma mark ----------------  兴趣标签接口  ------------------
#define HOBBY_TITLES_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_hobbytitles",BASE_URL]

#pragma mark **************  获取个人信息
#define GET_USERINFOMATION_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_userinfo",BASE_URL]
#pragma mark --------------  获取用户可用积分接口
#define GET_USER_SCORE_URL      [NSString stringWithFormat:@"%@?m=Task&a=find_integral",BASE_URL]

#pragma mark  *******************  接口修改  ********************
#pragma mark ------   注册登录相关  ——————————————————
/// 获取注册验证码接口
#define GET_REGISTER_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_getcode",BASE_URL]
/// 注册接口
#define ZHUCE_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_register",BASE_URL]
/// 检测验证码是否正确
#define CHECK_YANZHENGMA_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_VerifiCode",BASE_URL]
//获取登录验证码
#define LOGIN_VERIFICATION_CODE_URL [NSString stringWithFormat:@"%@?m=User&a=login_getCode",BASE_URL]
/// 登录接口
#define LOGIN_URL [NSString stringWithFormat:@"%@?m=User&a=getCode",BASE_URL]
///退出登录接口
#define LOG_OUT_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_logout",BASE_URL]
//增加邀请码接口
#define LOG_ADD_INVITATION_URL [NSString stringWithFormat:@"%@?m=User&a=user_invite",BASE_URL]
/// 修改密码获取验证码
#define PASSWORD_YANZHENGMA_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_forgetcode",BASE_URL]
/// 修改密码接口
#define PASSWORD_MODIFY_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_forgetpwd",BASE_URL]
/// 分享接口
#define SHARE_URL [NSString stringWithFormat:@"%@?m=Task&a=e_point_share",BASE_URL]

/// 分享到平台的链接地址
#define SHARE_CONTENT_URL [NSString stringWithFormat:@"%@?m=Task&a=e_point_record",BASE_URL]


#pragma mark  -----------  用户信息相关 -----------------
///绑定银行卡
#define BIND_BANK_URL [NSString stringWithFormat:@"%@?m=Apply&a=e_point_bindAccount",BASE_URL]
///修改绑定银行卡信息
#define MODIFY_BANK_INFO_URL [NSString stringWithFormat:@"%@?m=Apply&a=e_point_upbank",BASE_URL]
///用户提现
#define APPLY_MONEY_URL [NSString stringWithFormat:@"%@?m=Apply&a=e_point_sub",BASE_URL]


#pragma mark ————————————   任务相关  ————————————————
///获取任务标题
#define GET_TASK_TITLE_URL [NSString stringWithFormat:@"%@?m=Task&a=e_point_title",BASE_URL]
///获取用户分享任务
#define GET_USER_TASKS_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_usertask",BASE_URL]
//上传任务转发图片接口
#define TASK_UPLOAD_IMAGE_URL [NSString stringWithFormat:@"%@?m=User&a=upload_forward_image",BASE_URL]

#pragma mark ——————————   系统相关  ——————————————————
///获取开屏广告
#define GET_GUANGGAO_IMAGE_URL [NSString stringWithFormat:@"%@?m=Ad&a=e_point_getAd",BASE_URL]
///获取最新版本号接口
#define GET_NOW_VERSION_URL [NSString stringWithFormat:@"%@?m=Task&a=e_point_getVersion",BASE_URL]

#pragma mark ******************电影相关接口***********************
#define GET_MOVIE_LIST_URL 
#define GET_MOVIEW_DETAIL_URL(movieid) [NSString stringWithFormat:@"%@qrMovie?movieId=%@",BASE_MOVIE_URL,movieid]
//查询附近影院接口
#define GET_NEAR_CINEMA_URL [NSString stringWithFormat:@"%@qrLocalCinemas?",BASE_MOVIE_URL]
//电影评论列表
#define GET_MOVIE_COMMENTS_URL [NSString stringWithFormat:@"%@qrTmMovieScore?",BASE_MOVIE_URL]
//发表电影评论
#define M_PUBLISH_COMMENTS_URL [NSString stringWithFormat:@"%@addTmMovieScore?",BASE_MOVIE_URL]
//所有地区
#define GET_ALL_CITY_URL [NSString stringWithFormat:@"%@qrCitysByCinemas",BASE_MOVIE_URL]
#define SEARCH_NEARBY_CINEMAS_URL [NSString stringWithFormat:@"%@qrLocalCinemas?",BASE_MOVIE_URL]
//查看电影放映场次
#define QUERY_MOVIE_PLAY_TIME_URL [NSString stringWithFormat:@"%@qrMovieSequences?",BASE_MOVIE_URL]
//查询座位图
#define QUERY_CINEMA_SEAT_URL [NSString stringWithFormat:@"%@qrSeqSeats?",BASE_MOVIE_URL]
//添加待支付购票订单
#define M_ADD_MOVIE_ORDER [NSString stringWithFormat:@"%@addMovieOrder?",BASE_MOVIE_URL]
//取消待支付订单
#define M_REMOVE_MOVIE_ORDER [NSString stringWithFormat:@"%@addMovieOrder?",BASE_MOVIE_URL]
//订单支付
#define M_ORDER_PAY [NSString stringWithFormat:@"%@beforePay?",BASE_MOVIE_URL]
//查询卡信息接口
#define M_GET_CARD_INFO_URL [NSString stringWithFormat:@"%@qrNfaTicket?",BASE_MOVIE_URL]
//查询所在城市id
#define M_GET_CITY_ID_URL [NSString stringWithFormat:@"%@qrCityId?",BASE_MOVIE_URL]

#pragma mark ******************积分夺宝相关接口***********************
//夺宝活动列表接口
#define PRIZE_LIST_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_prizelist",BASE_URL]
//积分夺宝详情接口
#define PRIZE_DETAIL_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_prize",BASE_URL]
//抽奖接口
#define LOTTERY_PRIZE_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_lottery",BASE_URL]
//中奖名单
#define WINNER_LIST_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_winlist",BASE_URL]
//夺宝历史
#define LOTTERY_LIST_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_lotterylist",BASE_URL]
//绑定修改收货地址
#define ADDRESS_MANAGER_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_bindaddress",BASE_URL]
//获取分享标题
#define PRIZE_SHARE_TITLES_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_prizeTitles",BASE_URL]
//夺宝活动完成分享请求的接口地址
#define PRIZE_SHARE_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_prizeshare",BASE_URL]
/// 夺宝活动分享到平台的链接地址
#define PRIZE_SHARE_CONTENT_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_prizerecord",BASE_URL]
/// 领奖接口
#define PRIZE_CONVERT_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_getprize",BASE_URL]
// 抽奖次数查询接口
#define PRIZE_TIMES_URL [NSString stringWithFormat:@"%@?m=Jfb&a=e_point_prizetimes",BASE_URL]





#pragma mark ====================  HTTPS 请求  ========================
/**
 *  获取ip跟手机号码所在地
 */
#define GET_IP_PHONE_ADDRESS_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_task_area",BASE_URL]

#endif




