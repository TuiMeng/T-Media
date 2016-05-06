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

//微信
#define WECHAT_APPKEY       @"wx76014e777c514c47"
#define WECHAT_SECRET       @"050bee88dbec5fb6221e1830af0284b6"
#define WECHAT_MCHID        @"1319234701"
//商户API密钥，填写相应参数
#define PARTNER_ID          @"34EE39AE4A5262A220781A78A1DC4F6D"
#define WECHAT_CALLBACK_URL @"http://test.twttmob.com/Test_version/include/wxpay/xmkp_notify.php"

//高德地图key
#define AMAP_KEY            @"5ec3a1c302941db6046f74f673259efa"


#define WEBSITE @"http://www.twttmob.com"

#define WEBSITEH5 @"http://h5.twttmob.com/tuimengapp/"

#pragma mark - 图片
#define NAVIGATION_IMAGE [UIImage imageNamed:@"navigation_image"]
#define BACKGROUND_IMAGE [UIImage imageName:@"background_image.jpg"]
//加载默认图图片
#define DEFAULT_LOADING_BIG_IMAGE @"default_loading_big_image"
#define DEFAULT_LOADING_SMALL_IMAGE @"default_loading_small_image"

#define CURRENT_BUILD   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define APP_NAME        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]


#pragma mark 所有接口
#pragma mark -----------域名--------------
//#define BASE_URL          @"http://www.twttmob.com/api.php"
//#define BASE_URL            @"http://www.twttmob.com/apinew.php"
#define BASE_URL            @"http://test.twttmob.com/test_version.php"

//#define  BASE_MOVIE_URL     @"http://www.yingmile.com/tmmobile/mobile/"
#define BASE_MOVIE_URL      @"http://202.108.31.66:8088/tmmobile/mobile/"
//电影频道图片地址域名
#define BASE_MOVIE_IMAGE_URL @"http://www.yingmile.com/yml_img"


/*
#pragma mark - 获取开屏广告
#define GET_GUANGGAO_IMAGE_URL @"http://112.126.68.189/api.php?m=Ad&a=getAd"
#pragma mark -------------  获取最新版本号 -----
#define GET_NOW_VERSION_URL @"http://www.twttmob.com/api.php/Task/getVersion"

#pragma mark - 注册登陆相关
///获取验证码
//#define GET_REGISTER_URL @"http://112.126.68.189/api.php?m=User&a=get_code"
///张少南
#define GET_REGISTER_URL @"http://www.twttmob.com/apinew.php?m=User&a=e_point_getcode"

#pragma mark - 注册
//#define ZHUCE_URL @"http://112.126.68.189/api.php?m=User&a=register"
#define ZHUCE_URL @"http://www.twttmob.com/apinew.php?m=User&a=e_point_register"

#pragma mark - 检测验证码是否正确
#define CHECK_YANZHENGMA_URL @"http://112.126.68.189/api.php?m=User&a=VerifiCode"

#pragma mark - 登陆
#define LOGIN_URL @"http://112.126.68.189/api.php?m=User&a=login"

#pragma mark - 修改密码发送验证码
#define PASSWORD_YANZHENGMA_URL @"http://112.126.68.189/api.php?m=User&a=forget_code"

#pragma mark - 修改密码接口
#define PASSWORD_MODIFY_URL @"http://112.126.68.189/api.php?m=User&a=forget_pwd"

#pragma mark - 分享接口
#define SHARE_URL @"http://112.126.68.189/api.php?m=Task&a=share&task_id=%@&user_id=%@&share_type=%@&from_type=1"

#pragma mark - 分享详情url
#define SHARE_CONTENT_URL @"http://www.twttmob.com/api.php?m=Task&a=record&user_id=%@&task_id=%@"

#pragma mark - 获取用户积分情况
#define GET_SCORE_URL @"http://112.126.68.189/api.php?m=User&a=user_points&user_id=%@"

#define GET_USER_TASKS_URL @"http://112.126.68.189/api.php?m=User&a=user_task&user_id=%@&task_status=%d"
#pragma mark - 绑定银行卡
#define BIND_BANK_URL @"http://www.twttmob.com/api.php/Apply/bindAccount"
#pragma mark - 修改绑定的银行卡信息
#define MODIFY_BANK_INFO_URL @"http://112.126.68.189/api.php?m=Apply&a=up_bank"

#pragma mark - 获取任务标题
#define GET_TASK_TITLE_URL @"http://112.126.68.189/api.php?m=Task&a=title&task_id=%@"
#pragma mark - 用户提现
#define APPLY_MONEY_URL @"http://112.126.68.189/api.php?m=Apply&a=sub"
*/



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


#pragma mark  *******************  接口修改  ********************
#pragma mark ------   注册登录相关  ——————————————————
/// 获取验证码接口
#define GET_REGISTER_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_getcode",BASE_URL]
/// 注册接口
#define ZHUCE_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_register",BASE_URL]
/// 检测验证码是否正确
#define CHECK_YANZHENGMA_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_VerifiCode",BASE_URL]
/// 登录接口
#define LOGIN_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_login",BASE_URL]
///退出登录接口
#define LOG_OUT_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_logout",BASE_URL]
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
#define BIND_BANK_URL [NSString stringWithFormat:@"%@/Apply/e_point_bindAccount",BASE_URL]
///修改绑定银行卡信息
#define MODIFY_BANK_INFO_URL [NSString stringWithFormat:@"%@?m=Apply&a=e_point_upbank",BASE_URL]
///用户提现
#define APPLY_MONEY_URL [NSString stringWithFormat:@"%@?m=Apply&a=e_point_sub",BASE_URL]


#pragma mark ————————————   任务相关  ————————————————
///获取任务标题
#define GET_TASK_TITLE_URL [NSString stringWithFormat:@"%@?m=Task&a=e_point_title",BASE_URL]
///获取用户分享任务
#define GET_USER_TASKS_URL [NSString stringWithFormat:@"%@?m=User&a=e_point_usertask",BASE_URL]


#pragma mark ——————————   系统相关  ——————————————————
///获取开屏广告
#define GET_GUANGGAO_IMAGE_URL [NSString stringWithFormat:@"%@?m=Ad&a=e_point_getAd",BASE_URL]
///获取最新版本号接口
#define GET_NOW_VERSION_URL [NSString stringWithFormat:@"%@/Task/e_point_getVersion",BASE_URL]

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
#define GET_ALL_CITY_URL [NSString stringWithFormat:@"%@qrCitys",BASE_MOVIE_URL]
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




#pragma mark ====================  HTTPS 请求  ========================
#define BASE_HTTPS_URL @"https://www.twttmob.com/apinew.php"
/**
 *  获取ip跟手机号码所在地
 */
#define GET_IP_PHONE_ADDRESS_URL [NSString stringWithFormat:@"%@?m=Gift&a=e_point_task_area",BASE_URL]

#endif




