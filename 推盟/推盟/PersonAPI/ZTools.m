//
//  ZTools.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ZTools.h"

#define IPHONE6_HEIGHT 667.0f
#define IPHONE6_WIDTH 375.0f

@implementation ZTools

+(BOOL)isLogIn{
    return [[NSUserDefaults standardUserDefaults] boolForKey:LOGIN];
}
+(NSString *)getUid
{
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    return uid;//@"e161ab516092bcadd857d4a116cd8a06";
}
+(NSString *)getPhoneNum
{
    NSString * num = [[NSUserDefaults standardUserDefaults] objectForKey:PHONE_NUMBER];
    return num;
}
+(NSString*)getIPAddress{
    NSString * ip_address = [self replaceNullString:[[NSUserDefaults standardUserDefaults] objectForKey:IP_ADRESS] WithReplaceString:@""];
    return ip_address;
}
+(NSString*)getPhoneNumAddress{
    NSString * phone_address = [self replaceNullString:[[NSUserDefaults standardUserDefaults] objectForKey:PHONE_ADDRESS] WithReplaceString:@""];
    return phone_address;
}
+(NSString*)getGPSAddress{
    NSString * phone_address = [self replaceNullString:[[NSUserDefaults standardUserDefaults] objectForKey:GPS_ADDRESS] WithReplaceString:@""];
    return phone_address;
}

+(NSString *)getUserName
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"user_name"];
}
+(int)getGrade{
    return [[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"grade"] intValue];
}
+(NSString*)getInvitationCode{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"invite_code"];
}
+(NSString*)getUserHobby{
    NSString * userHobby = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"hobby_id"];
    if (userHobby.length > 0 && ![userHobby isKindOfClass:[NSNull class]] && [userHobby rangeOfString:@"null"].length == 0) {
        return userHobby;
    }
    return @"";
}
+(NSString*)getRestMoney{
    NSString * rest_string = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"rest_money"]];
    if (rest_string.length > 0 && ![rest_string isKindOfClass:[NSNull class]] && [rest_string rangeOfString:@"null"].length == 0) {
        return rest_string;
    }
    return @"0.00";
}
+(NSString*)getAllMoney{
    NSString * rest_string = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"all_money"]];
    if (rest_string.length > 0 && ![rest_string isKindOfClass:[NSNull class]] && [rest_string rangeOfString:@"null"].length == 0) {
        return rest_string;
    }
    return @"0.00";
}
+(NSString*)getMoney{
    NSString * rest_string = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"money"]];
    if (rest_string.length > 0 && ![rest_string isKindOfClass:[NSNull class]] && [rest_string rangeOfString:@"null"].length == 0) {
        return rest_string;
    }
    return @"0.00";
}
+(NSString*)getBankCard{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"bank_card"];
}
+(NSString*)getAlipayNum{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"alipay_num"];
}
+(NSString*)getInvitedMoney{
    NSString * rest_string = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"invited_money"]];
    if (rest_string.length > 0 && ![rest_string isKindOfClass:[NSNull class]] && [rest_string rangeOfString:@"null"].length == 0) {
        return rest_string;
    }
    return @"0";
}
+(NSString*)getBeInvitedMoney{
    NSString * rest_string = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"be_invited_money"]];
    if (rest_string.length > 0 && ![rest_string isKindOfClass:[NSNull class]] && [rest_string rangeOfString:@"null"].length == 0) {
        return rest_string;
    }
    return @"0";
}
+(void)logOut{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"UserInfomationData"];
    [user removeObjectForKey:LOGIN];
    [user removeObjectForKey:UID];
    [user removeObjectForKey:PHONE_NUMBER];
    [user removeObjectForKey:PHONE_ADDRESS];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogOut" object:nil];
}

+(NSString*)getDeviceToken{
    NSString * token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"devicePushToken"]];
    if (token.length > 0 && ![token isKindOfClass:[NSNull class]] && [token rangeOfString:@"null"].length == 0) {
        return token;
    }
    return @"";
}
#pragma mark ---  获取用户所选地区
+(NSString *)getSelectedCity{
    id area = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChooseArea"];
    if (area && [area isKindOfClass:[NSDictionary class]]) {
        return [area objectForKey:@"city"];
    }else{
        return @"北京";
    }
}
#pragma mark ----  获取用户所选地区Id
+(NSString *)getSelectedCityId{
    id area = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChooseArea"];
    if (area && [area isKindOfClass:[NSDictionary class]]) {
        return [area objectForKey:@"cityId"];
    }else{
        return @"110000";
    }
}
#pragma mark ----   设置默认地区
+(void)setSelectedCity:(NSString *)city cityId:(NSString *)cityId{
    [[NSUserDefaults standardUserDefaults] setObject:@{@"city":city,@"cityId":cityId} forKey:@"ChooseArea"];
}


#pragma mark - 根据高度按比例适配大小（基于iphone6大小）
+(CGFloat)autoHeightWith:(CGFloat)aHeight{
    return aHeight*DEVICE_HEIGHT/IPHONE6_HEIGHT;
}
#pragma mark - 根据宽度按比例适配大小（基于iphone6大小）
+(CGFloat)autoWidthWith:(CGFloat)aWidth{
    return aWidth*DEVICE_WIDTH/IPHONE6_WIDTH;
}

///NSDate转换成NSString 已自定义的格式(例：YYYY-MM-dd HH:mm:ss)
+(NSString *)timechangeWithDate:(NSDate *)date WithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}
///把当前时间转换成时间戳
+(NSString *)timechangeToDateline
{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}
///把当前时间转换成时间戳
+(NSString *)timechangeToDatelineWithDate:(NSDate *)date{
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}
///时间戳转换成NSString 已自定义的格式(例：YYYY-MM-dd HH:mm:ss)
+(NSString *)timechangeWithTimestamp:(NSString *)placetime WithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
//判断日期是今天，昨天还是明天
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay    = 24 * 60 * 60;
    NSDate *today                   = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow                = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday               = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString  = [[today description] substringToIndex:10];
    NSString * yesterdayString  = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString   = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString       = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}
+ (NSString *)timeIntervalFromNowWithformateDate:(NSString *)dateString
{
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [NSDate dateWithTimeIntervalSince1970:[dateString intValue]];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}
//判断NSDate是星期几
+(NSString*)timeWeekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:inputDate];
    return weekdays[comps.weekday];
}

#pragma mark - 显示提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text WihtType:(MBProgressHUDMode)theModel addToView:(UIView *)aView isAutoHidden:(BOOL)hidden
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = theModel;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    if (hidden) {
        [hud hide:hidden afterDelay:1.5];
    }
    return hud;
}

+(NSString *)showErrorWithStatus:(NSString *)status InView:(UIView *)view isShow:(BOOL)isShow
{
    NSString * error_string = @"请求失败";
    
    switch ([status intValue]) {
        case 100:
            error_string = @"手机号格式不正确";
            break;
        case 101:
            error_string = @"该手机号已被使用";
            break;
        case 103:
            error_string = @"验证码输入错误";
            break;
        case 104:
            error_string = @"密码格式不正确";
            break;
        case 105:
            error_string = @"请重新获取验证码";
            break;
        case 106:
            error_string = @"该手机号已被使用";
            break;
        case 107:
            error_string = @"注册失败";
            break;
        case 108:
            error_string = @"用户名格式不正确";
            break;
        case 109:
            error_string = @"该用户名已被使用";
            break;
        case 110:
            error_string = @"请设定头像信息";
            break;
        case 111:
            error_string = @"设置用户信息失败";
            break;
        case 112:
            error_string = @"单位名称设置错误";
            break;
        case 113:
            error_string = @"工作年限设置错误";
            break;
        case 114:
            error_string = @"请设定认证图像";
            break;
        case 115:
            error_string = @"设置认证信息失败";
            break;
        case 116:
            error_string = @"请填写用户名/手机号进行登录";
            break;
        case 117:
            error_string = @"该用户不存在";
            break;
        case 118:
            error_string = @"密码输入错误";
            break;
        case 119:
            error_string = @"您的账号已被冻结";
            break;
        case 120:
            error_string = @"该手机号未注册";
            break;
        case 121:
            error_string = @"修改密码失败";
            break;
        case 122:
            error_string = @"该用户不存在";
            break;
        case 123:
            error_string = @"头像信息修改失败";
            break;
        case 124:
            error_string = @"手机号修改失败";
            break;
        case 125:
            error_string = @"修改认证信息失败";
            break;
        case 126:
            error_string = @"旧密码输入错误";
            break;
        case 127:
            error_string = @"新密码格式错误";
            break;
        case 128:
            error_string = @"两次密码不一致";
            break;
        case 200:
            error_string = @"暂时没有可开放的任务";
            break;
        case 201:
            error_string = @"该任务已经完成";
            break;
        case 300:
            error_string = @"提现金额须大于等于500";
            break;
        case 301:
            error_string = @"您有未处理的提现申请";
            break;
        case 302:
            error_string = @"用户可提现金额不足";
            break;
        case 303:
            error_string = @"用户提现申请提交失败";
            break;
        case 304:
            error_string = @"银行卡号格式不正确";
            break;
        case 305:
            error_string = @"银行卡户名长度错误";
            break;
        case 306:
            error_string = @"银行卡绑定失败";
            break;
        case 307:
            error_string = @"修改银行卡绑定失败";
            break;
            
        default:
            break;
    }
    
    if (isShow)
    {
        MBProgressHUD * hud = [ZTools showMBProgressWithText:error_string WihtType:MBProgressHUDModeText addToView:view isAutoHidden:YES];
        
        [hud hide:YES afterDelay:1.5f];
    }
    return error_string;
}

#pragma mark - 计算字符串高度
+(CGSize)stringHeightWithFont:(UIFont*)font WithString:(NSString*)string WithWidth:(float)width{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize;
}

#pragma mark - 统一字体
+(UIFont *)returnaFontWith:(CGFloat)aSize
{
//    return [UIFont fontWithName:DEFAULT_FONT size:aSize];
    return [UIFont systemFontOfSize:aSize];
}

#pragma mark ----   将手机号码中间四位改为*
+(NSString *)returnEncryptionMobileNumWith:(NSString *)num{
    
    if (num.length != 11) {
        return num;
    }
    
    return [num stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

#pragma mark -----   改变label某些字体颜色
+(NSMutableAttributedString *)labelTextColorWith:(NSString *)label_str Color:(UIColor *)color range:(NSRange)range{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label_str];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    return str;
}
#pragma mark -----   改变label某些字体大小及颜色
+(NSMutableAttributedString *)labelTextFontWith:(NSString *)label_str Color:(UIColor *)color Font:(float)afont range:(NSRange)range{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label_str];
    [str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:afont] range:range];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    return str;
}

#pragma mark ----  创建UITextField
+(STextField*)createTextFieldWithFrame:(CGRect)frame
                                   tag:(int)tag
                                  font:(float)font
                           placeHolder:(NSString*)placeHolder
                       secureTextEntry:(BOOL)scure{
    STextField * textField = [[STextField alloc] initWithFrame:frame];
    textField.font = [ZTools returnaFontWith:font];
    textField.placeholder = placeHolder;
    textField.tag = tag;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    textField.layer.borderWidth = 0.5;
    textField.secureTextEntry = scure;
    
    return textField;
}
+(STextField*)createTextFieldWithFrame:(CGRect)frame
                                  font:(float)font
                           placeHolder:(NSString*)placeHolder
                       secureTextEntry:(BOOL)scure{
    STextField * textField = [[STextField alloc] initWithFrame:frame];
    textField.font = [ZTools returnaFontWith:font];
    textField.placeholder = placeHolder;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    textField.layer.borderWidth = 0.5;
    textField.secureTextEntry = scure;
    
    return textField;
}


+(UIButton*)createButtonWithFrame:(CGRect)frame
                              tag:(int)tag
                            title:(NSString *)title
                            image:(UIImage*)image{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    button.layer.cornerRadius = 5;
    return button;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame
                            title:(NSString *)title
                            image:(UIImage*)image{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    button.layer.cornerRadius = 5;
    return button;
}


+(UILabel *)createLabelWithFrame:(CGRect)frame
                             tag:(int)tag
                            text:(NSString *)text
                       textColor:(UIColor*)color
                   textAlignment:(NSTextAlignment)textAlignment
                            font:(float)font{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.tag = tag;
    label.text = text;
    label.textColor = color;
    label.textAlignment = textAlignment;
    label.font = [ZTools returnaFontWith:font];
    
    return label;
}

+(UILabel *)createLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                       textColor:(UIColor*)color
                   textAlignment:(NSTextAlignment)textAlignment
                            font:(float)font{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = textAlignment;
    label.font = [ZTools returnaFontWith:font];
    
    return label;
}

+(NSString*)replaceNullString:(NSString*)string WithReplaceString:(NSString*)replace{
    if (string.length != 0 && ![string isKindOfClass:[NSNull class]] && [string rangeOfString:@"null"].length == 0 && ![string isEqualToString:@"<null>"]) {
        return string;
    }
    
    return replace;
}

#pragma mark **************判断地区是否超过两个字符，如果超过截取，保留两个字符****************
+(NSString*)CutAreaString:(NSString*)area{
    if (area.length > 2 && area.length < 4) {
        area = [area substringToIndex:2];
    }
    
    if (area.length >= 4) {
        area = [area substringToIndex:3];
    }
    
    return area;
}

+(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
+(NSString*)replaceUtf8CodingWithString:(NSString*)str{
    
    if (str.length==0 || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(UIImage *)shotScreenWithView:(UIView *)view size:(CGSize)size scale:(float)zoomScale{
    UIGraphicsBeginImageContextWithOptions(size, NO, zoomScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return uiImage;
}


@end
