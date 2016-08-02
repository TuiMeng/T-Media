//
//  ZTools.h
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STextField.h"
#import "UserInfoModel.h"

@interface ZTools : NSObject
//判断是否登陆
+(BOOL)isLogIn;
//获取上次登录时间
+(NSString *)loginTime;
//获取uid
+(NSString *)getUid;
//获取用户电话号码
+(NSString *)getPhoneNum;
//获取ip地址
+(NSString*)getIPAddress;
//获取手机号码地区
+(NSString*)getPhoneNumAddress;
//获取gps获取到的地区
+(NSString*)getGPSAddress;
//获取用户名
+(NSString *)getUserName;
//获取用户真实姓名
+(NSString *)getRealUserName;
//获取用户身份证号
+(NSString *)getIDNumber;
//获取等级
+(int)getGrade;
//获取用户兴趣爱好
+(NSString*)getUserHobby;
//获取邀请码
+(NSString *)getInvitationCode;
//获取可用余额
+(NSString*)getRestMoney;
//获取总额
+(NSString*)getAllMoney;
//获取提现金额
+(NSString*)getMoney;
//获取银行卡号
+(NSString*)getBankCard;
//获取支付宝
+(NSString*)getAlipayNum;
//获取邀请人获取的奖励
+(NSString *)getInvitedMoney;
//获取被邀请人获取的奖励
+(NSString *)getBeInvitedMoney;
//退出登陆
+(void)logOut;
+(NSString*)getDeviceToken;
//获取收货人地址信息
+(UserAddressModel *)getAddressModel;
//设置默认地区
+(void)setSelectedCity:(NSString *)city cityId:(NSString *)cityId;
//获取默认地区
+(NSString *)getSelectedCity;
+(NSString *)getSelectedCityId;

///根据高度按比例适配大小（基于iphone6大小）
+(CGFloat)autoHeightWith:(CGFloat)aHeight;
///根据宽度按比例适配大小（基于iphone6大小）
+(CGFloat)autoWidthWith:(CGFloat)aWidth;

/**
 *  NSDate转换成NSString 
 *
 *  @param date   目标时间
 *  @param format 自定义返回格式（例：YYYY-MM-dd HH:mm:ss）
 */
+(NSString *)timechangeWithDate:(NSDate *)date WithFormat:(NSString *)format;
/**
 *  NSDate转时间戳
 */
+(NSString *)timechangeToDatelineWithDate:(NSDate *)date;
/**
 *  NSDate转时间戳
 */
+(NSString *)timechangeToDateline;
/**
 *  时间戳转换成需要格式
 *
 *  @param placetime 时间戳
 *  @param format 自定义返回格式（例：YYYY-MM-dd HH:mm:ss）
 */
+(NSString *)timechangeWithTimestamp:(NSString *)placetime WithFormat:(NSString *)format;
/**
 *  判断日期是今天，昨天还是明天
 */
-(NSString *)compareDate:(NSDate *)date;
/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/
+ (NSString *)timeIntervalFromNowWithformateDate:(NSString *)dateString;
/**
 *  判断该日期为星期几
 */
+(NSString*)timeWeekdayStringFromDate:(NSDate*)inputDate;
#pragma mark - 显示提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text WihtType:(MBProgressHUDMode)theModel addToView:(UIView *)aView isAutoHidden:(BOOL)hidden;
/**
 *  显示数据请求错误详细信息
 */
+(NSString *)showErrorWithStatus:(NSString *)status InView:(UIView *)view isShow:(BOOL)isShow;
/**
 *  根据字体大小  宽度  计算字符串高度
 *
 *  @param font   字符大小
 *  @param string 要处理的字符串
 *  @param width  要显示的宽度
 */
+(CGSize)stringHeightWithFont:(UIFont*)font WithString:(NSString*)string WithWidth:(float)width;
/**
 *  统一字体
 *
 *  @param aSize 字体大小
 */
+(UIFont *)returnaFontWith:(CGFloat)aSize;
/**
 *  将手机号码中间四位改为****
 *
 *  @param num 需要转换的手机号码
 */
+(NSString *)returnEncryptionMobileNumWith:(NSString *)num;
/**
 *  改变label某些字体颜色
 *
 *  @param label_str 目标字符串
 *  @param color     颜色
 *  @param range     位置
 */
+(NSMutableAttributedString *)labelTextColorWith:(NSString *)label_str Color:(UIColor *)color range:(NSRange)range;
/**
 *改变label某些字体的大小
 */
+(NSMutableAttributedString *)labelTextFontWith:(NSString *)label_str Color:(UIColor *)color Font:(float)afont range:(NSRange)range;
/**
 *  创建UITextField
*/
+(STextField*)createTextFieldWithFrame:(CGRect)frame tag:(int)tag font:(float)font placeHolder:(NSString*)placeHolder secureTextEntry:(BOOL)scure;
+(STextField*)createTextFieldWithFrame:(CGRect)frame font:(float)font placeHolder:(NSString*)placeHolder secureTextEntry:(BOOL)scure;

+(UIButton*)createButtonWithFrame:(CGRect)frame tag:(int)tag title:(NSString *)title image:(UIImage*)image;
+(UIButton*)createButtonWithFrame:(CGRect)frame
                            title:(NSString *)title
                            image:(UIImage*)image;

+(UILabel *)createLabelWithFrame:(CGRect)frame tag:(int)tag text:(NSString *)text textColor:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment font:(float)font;
+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment font:(float)font;

/**
 *  先判断字符串是否为空，不为空返回字符串本身，为空的返回指定的字符串
 *
 *  @param string  目标字符串
 *  @param replace 被替换的字符串
 */
+(NSString*)replaceNullString:(NSString*)string WithReplaceString:(NSString*)replace;
/**
 *  判断字符串长度大于2小于4，截取前两个字符，大于4的截取前三个字符
 */
+(NSString*)CutAreaString:(NSString*)area;
/**
 *  改变图片大小
 */
+(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
/**
 *  图片按比例缩放
 */
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
/**
 *  将目标字符串转换成utf8格式
 */
+(NSString*)replaceUtf8CodingWithString:(NSString*)str;
/**
 * 放大缩小放大动画
 */
+(void)cureInAnimationWithView:(UIView *)view;
/**
 *  生成图片根据已有颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  截屏
 */
+(UIImage *)shotScreenWithView:(UIView *)view size:(CGSize)size scale:(float)zoomScale;
/**
 *  截屏并模糊处理
 */
+(UIImage *)screenShotVague;

+(NSString *)linkAllAddressWithImageAddress:(NSString *)url;
/**
 *  加密字符
 *
 *  @param dateline 时间戳
 *
 *  @return 签名
 */
+(NSString *)signWithDateLine:(NSString *)dateline;

@end















