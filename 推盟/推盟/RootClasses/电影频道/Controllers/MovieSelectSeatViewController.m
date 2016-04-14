//
//  MovieSelectSeatViewController.m
//  推盟
//
//  Created by joinus on 16/3/10.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieSelectSeatViewController.h"
#import "MSelectSeatView.h"
#import "SeatModel.h"
#import "MConfirmOrderViewController.h"
#import "UIAlertView+Blocks.h"
#import "MovieNetWork.h"


#define MAX_SEATS_LIMIT @"一次最多选择5个座位"

@interface MovieSelectSeatViewController (){
    UIView          * header_view;
    UIView          * bottomView;
    UIScrollView    * selectedSeatScrollView;
    MSelectSeatView * seclectSeatView;
    UIButton        * doneButton;
    UILabel         * limitLabel;
}

@property(nonatomic,strong)NSMutableArray   * dataArray;
@property(nonatomic,strong)NSMutableArray   * selectedSeatArray;
//订单号
@property(nonatomic,strong)NSString         * orderId;

@end


@implementation MovieSelectSeatViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = _movie_model.movieName;
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypeBack WihtLeftString:@"backImage"];
    
    _dataArray         =   [NSMutableArray array];
    _selectedSeatArray =   [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    
    [self setMainView];
    
    [self loadData];
}

-(void)leftButtonTap:(UIButton *)sender{
    if (_orderId) {
        __weak typeof(self)wself = self;
        UIAlertView * alertView = [UIAlertView showWithTitle:@"返回后，您当前选中的座位将不再保留"
                                                     message:@""
                                           cancelButtonTitle:@"返回"
                                           otherButtonTitles:@[@"继续选座"]
                                                    tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex){
            if (buttonIndex == 0) {
                [[MovieNetWork sharedManager] releaseMovieSeatsWithOrderId:wself.orderId];
                [wself.navigationController popViewControllerAnimated:YES];
            }
        }];
        [alertView show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ------  创建主视图
-(void)setMainView{
    
    if (!header_view) {
        header_view                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
        header_view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:header_view];
        //影院名称
        UILabel * cinema_name_label = [ZTools createLabelWithFrame:CGRectMake(15, 10, DEVICE_WIDTH-30, 20)
                                                              text:_cinema_model.cinemaName
                                                         textColor:DEFAULT_BLACK_TEXT_COLOR
                                                     textAlignment:NSTextAlignmentLeft
                                                              font:16];
        [header_view addSubview:cinema_name_label];
        //电影介绍（时间 属性）
        UILabel * movie_info_label  = [ZTools createLabelWithFrame:CGRectMake(15, cinema_name_label.bottom+5, DEVICE_WIDTH-30, 18)
                                                              text:@"明天 3月4日 11:20 国语3D"
                                                         textColor:DEFAULT_GRAY_TEXT_COLOR
                                                     textAlignment:NSTextAlignmentLeft
                                                              font:12];
        [header_view addSubview:movie_info_label];
        //分割线
        UIView * MiddlelineView     = [[UIView alloc] initWithFrame:CGRectMake(0, movie_info_label.bottom+10, DEVICE_WIDTH, 0.5)];
        MiddlelineView.backgroundColor = DEFAULT_LINE_COLOR;
        [header_view addSubview:MiddlelineView];
        
        NSArray * imageArray        = @[[UIImage imageNamed:@"m_seat_unselected_image"],[UIImage imageNamed:@"m_seat_hadBuy_image"],[UIImage imageNamed:@"m_seat_selected_image"],[UIImage imageNamed:@"m_seat_lover_unselected_image"]];
        NSArray * titleArray = @[@"可选",@"已售",@"已选",@"情侣座"];
        for (int i = 0; i < 4; i++) {
            UIImage * image = imageArray[i];
            UIButton * button       = [ZTools createButtonWithFrame:CGRectMake((DEVICE_WIDTH-30-280)/2.0f+75*i, MiddlelineView.bottom + 10, 70, 20) title:titleArray[i] image:image];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            button.backgroundColor = [UIColor whiteColor];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width)];
            [button setTitleColor:DEFAULT_BLACK_TEXT_COLOR forState:UIControlStateNormal];
            button.titleLabel.font  = [ZTools returnaFontWith:11];
            [header_view addSubview:button];
        }
        
        //分割线
        UIView * headerBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, header_view.height-0.5, DEVICE_WIDTH, 0.5)];
        headerBottomLineView.backgroundColor = DEFAULT_LINE_COLOR;
        [header_view addSubview:headerBottomLineView];
        
        
        //底部视图
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-110-64, DEVICE_WIDTH, 110)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        //分割线
        UIView * bottomTopLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
        bottomTopLineView.backgroundColor = DEFAULT_LINE_COLOR;
        [bottomView addSubview:bottomTopLineView];
        
        UILabel * selectedTextLabel = [ZTools createLabelWithFrame:CGRectMake(15, 5, DEVICE_WIDTH-30, 15) text:@"已选座位" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
        [bottomView addSubview:selectedTextLabel];
        
        selectedSeatScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, selectedTextLabel.bottom + 5, DEVICE_WIDTH-30, 30)];
        [bottomView addSubview:selectedSeatScrollView];
        
        //分割线
        UIView * bottomMiddleLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 60, DEVICE_WIDTH-30, 0.5)];
        bottomMiddleLineView.backgroundColor = DEFAULT_LINE_COLOR;
        [bottomView addSubview:bottomMiddleLineView];
        //购买按钮
        doneButton                              = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-140-15,bottomMiddleLineView.bottom + 5, 140, 40) title:@"请先选座" image:nil];
        doneButton.backgroundColor              = RGBCOLOR(253, 152, 39);//RGBCOLOR(255, 224, 178);
        doneButton.clipsToBounds                = YES;
        doneButton.enabled                      = NO;
        doneButton.adjustsImageWhenHighlighted  = NO;
        [doneButton setBackgroundImage:[UIImage imageNamed:@"mBuyButtonAbledImage"] forState:UIControlStateNormal];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"mBuyButtonEnbledImage"] forState:UIControlStateDisabled];
        [doneButton setTitle:@"请先选座" forState:UIControlStateDisabled];
        [doneButton setTitle:@"确认选座" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:doneButton];
        //限制介绍
        limitLabel = [ZTools createLabelWithFrame:CGRectMake(15, doneButton.top, doneButton.left-30, doneButton.height) text:MAX_SEATS_LIMIT textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
        limitLabel.numberOfLines = 0;
        [bottomView addSubview:limitLabel];
    }
    
    if (_dataArray.count) {
        //座位图
        seclectSeatView = [[MSelectSeatView alloc] initWithFrame:CGRectMake(0, header_view.bottom, DEVICE_WIDTH, DEVICE_HEIGHT-64-header_view.height-bottomView.height) WithSeatArray:_dataArray];
        [self.view addSubview:seclectSeatView];
        
        __weak typeof(self)wself = self;
        [seclectSeatView selectSeatClicked:^(SeatModel * model) {
            [wself selectedSeatClickedWithSeatModel:model];
            if ([wself.selectedSeatArray[0] count]) {
                doneButton.enabled  = YES;
                doneButton.selected = YES;
                [wself updateLimitLabelText];
            }else{
                doneButton.enabled   = NO;
                doneButton.selected  = NO;
                limitLabel.textColor = DEFAULT_BLACK_TEXT_COLOR;
                limitLabel.text = MAX_SEATS_LIMIT;
            }
        }];
    }
}

#pragma mark -----  网络请求
-(void)loadData{
    
    [self startLoading];
    __weak typeof(self)wself = self;
    NSDictionary * dic = @{@"seqId":_sequenceModel.seqId};
    [[ZAPI manager] sendPost:QUERY_CINEMA_SEAT_URL myParams:dic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSArray class]]) {
            BOOL middleShow = YES;
            for (NSArray * array in data) {
                NSMutableArray * rowArray   = [NSMutableArray array];
                BOOL frontShow              = YES;
                for (NSDictionary * item in array) {
                    SeatModel * model       = [[SeatModel alloc] initWithDictionary:item];
                    [rowArray addObject:model];
                    if (model.seatId.length != 0) {
                        frontShow           = NO;
                        middleShow          = NO;
                    }
                }
                if (frontShow) {
                    [rowArray removeAllObjects];
                }
                if (!middleShow || !frontShow) {
                    [wself.dataArray addObject:rowArray];
                }
            }
        }
        [wself setMainView];
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}

#pragma mark ------  添加/删除座位
-(void)selectedSeatClickedWithSeatModel:(SeatModel *)model{
    if ([_selectedSeatArray[0] containsObject:model]) {
        NSInteger index = [_selectedSeatArray[0] indexOfObject:model];
        [_selectedSeatArray[0] removeObjectAtIndex:index];
        [_selectedSeatArray[1] removeObjectAtIndex:index];
        
        [self scrollViewUpdateContentView];
    }else{
        [_selectedSeatArray[0] addObject:model];
        UIButton * button           = [ZTools createButtonWithFrame:CGRectMake(([_selectedSeatArray[0] count]-1)*75, 2.5, 70, 25) title:model.seatCode image:nil];
        button.backgroundColor      = [UIColor whiteColor];
        button.layer.borderColor    = RGBCOLOR(227, 227, 227).CGColor;
        button.layer.borderWidth    = 0.5;
        button.layer.cornerRadius   = 3;
        button.titleLabel.font      = [ZTools returnaFontWith:12];
        [button setTitleColor:DEFAULT_BLACK_TEXT_COLOR forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteSeatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [selectedSeatScrollView addSubview:button];
        [_selectedSeatArray[1] addObject:button];
    }
}

-(void)scrollViewUpdateContentView{
    
    selectedSeatScrollView.contentSize = CGSizeMake(75*[_selectedSeatArray[0] count], 0);
    
    int x = 0;
    for (id obj in selectedSeatScrollView.subviews) {
        
        if (obj && [obj isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton*)obj;
            if ([_selectedSeatArray[1] containsObject:button]) {
                [UIView animateWithDuration:0.3 animations:^{
                    button.left = x*75;
                } completion:^(BOOL finished) {
                    
                }];
                
                x++;
            }else{
                [button removeFromSuperview];
            }
        }
    }
}

#pragma mark ------  删除选中座位
-(void)deleteSeatButtonClicked:(UIButton*)button{
    NSInteger index = [_selectedSeatArray[1] indexOfObject:button];
    
    SeatModel * model = _selectedSeatArray[0][index];
    [seclectSeatView deleteSeatWithSeatModel:model];
}

#pragma mark ------  修改价格
-(void)updateLimitLabelText{
    limitLabel.textColor = DEFAULT_GRAY_TEXT_COLOR;
    
    NSString * priceString = [NSString stringWithFormat:@"%.1f元\n%@元X%d",[_sequenceModel.price floatValue]*[_selectedSeatArray[0] count],_sequenceModel.price,(int)[_selectedSeatArray[0] count]];
    //改字体大小
    NSRange priceRange1 = [priceString rangeOfString:[NSString stringWithFormat:@"%.1f",[_sequenceModel.price floatValue]*[_selectedSeatArray[0] count]]];
    //改字体颜色
    NSRange priceRange2 = [priceString rangeOfString:[NSString stringWithFormat:@"%.1f元",[_sequenceModel.price floatValue]*[_selectedSeatArray[0] count]]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceString];
    [str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:18] range:priceRange1];
    [str addAttribute:NSForegroundColorAttributeName value:DEFAULT_ORANGE_TEXT_COLOR range:priceRange2];

    limitLabel.attributedText = str;
}

#pragma mark ------------  购买
-(void)buyButtonClicked:(UIButton *)button{
    NSLog(@"buy buy buy");
    
//    [self pushToConfirOrderViewController];
    
    [self prepareForPay];
    
}

#pragma mark ---------   生成订单号
-(NSString * )buildOrderId{
    if (!_orderId) {
        _orderId = [NSString stringWithFormat:@"%@%04d%@",[ZTools timechangeToDateline],arc4random()%10000,_movie_model.movieId];
    }
    return _orderId;
}

-(void)prepareForPay{
    
    if (![ZTools isLogIn]) {
        UIStoryboard *storyboard        = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController * login  = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
        [self presentViewController:login animated:YES completion:nil];
        
        return;
    }
    
    BOOL isSure = YES;
    
    for (SeatModel * model in _selectedSeatArray[0]) {
        for (NSMutableArray * array in _dataArray) {
            if ([array containsObject:model]) {
                
                int index = (int)[array indexOfObject:model];
                
                if (index != 0 && index != array.count-1) {
                    int preIndex = index-1;
                    int lastIndex = index+1;
                    
                    if (preIndex >= 0) {
                        SeatModel * preModel = array[preIndex];
                        if (preModel.seatStatus.intValue == 2) {
                            //如果前一项为空
                            int preIndex2 = preIndex-1;
                            if (preIndex2 >= 0) {
                                SeatModel * preModel2 = array[preIndex2];
                                
                                if (preModel2.seatStatus.intValue == 0) {
                                    if (preModel.seatStatus.intValue == 2 && ![_selectedSeatArray[0] containsObject:preModel]) {
                                        isSure = NO;
                                    }
                                }else{
                                    if (preModel2.seatStatus.intValue != 2 && ![_selectedSeatArray[0] containsObject:preModel2]) {
                                        isSure = NO;
                                    }
                                }
                                
                            }
                        }
                        
                        if (preIndex == 0 && preModel.seatStatus.intValue == 2 && ![_selectedSeatArray[0] containsObject:array[preIndex]]) {
                            isSure = NO;
                        }
                    }
                    
                    if (lastIndex <= array.count-1) {
                        
                        SeatModel * lastModel = array[lastIndex];
                        if (lastModel.seatStatus.intValue == 2) {
                            int lastIndex2 = lastIndex+1;
                            if (lastIndex2 <= array.count-1) {
                                SeatModel * lastModel2 = array[lastIndex2];
                                
                                if (lastModel2.seatStatus.intValue == 0) {
                                    if (lastModel.seatStatus.intValue == 2 && ![_selectedSeatArray[0] containsObject:lastModel]) {
                                        isSure = NO;
                                    }
                                }else{
                                    if (lastModel2.seatStatus.intValue != 2 && ![_selectedSeatArray[0] containsObject:lastModel2]) {
                                        isSure = NO;
                                    }
                                }
                            }
                        }
                        
                        if (lastIndex == array.count-1 && lastModel.seatStatus.intValue == 2 && ![_selectedSeatArray[0] containsObject:array[lastIndex]]) {
                            isSure = NO;
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    
    if (!isSure) {
        UIAlertView * alertView = [UIAlertView showWithTitle:@"温馨提示" message:@"选座时，请尽量选连在一起的座位，不要留下单个的空闲座位!" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
        }];
        
        [alertView show];
        
        return;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:00",_sequenceModel.seqDate,_sequenceModel.seqTime]];
    NSString * dateline = [ZTools timechangeToDatelineWithDate:date];

    
    MBProgressHUD * loadHUD = [ZTools showMBProgressWithText:@"订单提交中..." WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:NO];
    
    __weak typeof(self)wself = self;
    NSArray * seatsInfoArray = [self getTickets];
    NSDictionary * dic = @{@"user_id"       :[ZTools getUid],
                           @"cinema_id"     :_cinema_model.cinemaId,
                           @"movie_id"      :_movie_model.movieId,
                           @"plan_id"       :_sequenceModel.seqId,
                           @"movie_money"   :_sequenceModel.price,
                           @"tickts"        :seatsInfoArray[0],
                           @"tickts_amount" :[NSString stringWithFormat:@"%d",(int)[_selectedSeatArray[0] count]],
                           @"hall_name"     :_sequenceModel.hallId,
                           @"pay_no"        :[self buildOrderId],
                           @"feature_time"  :dateline,
                           @"ticket_desc"   :seatsInfoArray[1],
                           @"mobile"        :[ZTools getPhoneNum]};
    
    
    [[ZAPI manager] sendPost:MOVIE_ADD_MOVIE_ORDER myParams:dic success:^(id data) {
        [loadHUD hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = data[ERROR_CODE];
            if (status.intValue == 1) {
                [wself pushToConfirOrderViewController];
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }else{
            [ZTools showMBProgressWithText:@"提交订单失败，请重试" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
        
    } failure:^(NSError *error) {
        wself.orderId = @"";
        [loadHUD hide:YES];
        [ZTools showMBProgressWithText:@"提交订单失败，请检查当前网络状况" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

-(void)pushToConfirOrderViewController{
    MConfirmOrderViewController * viewController = [[MConfirmOrderViewController alloc] init];
    viewController.sequenceModel                 = _sequenceModel;
    viewController.seatArray                     = _selectedSeatArray[0];
    viewController.cinema_model                  = _cinema_model;
    viewController.movie_model                   = _movie_model;
    viewController.orderId                       = _orderId;
    [self.navigationController pushViewController:viewController animated:YES];

}

-(NSArray *)getTickets{
    NSMutableArray  * tickets   = [NSMutableArray array];
    NSMutableArray  * seats     = [NSMutableArray array];
    for (SeatModel * model in _selectedSeatArray[0]) {
        [tickets addObject:model.seatId];
        [seats addObject:model.seatCode];
    }
    
    return @[[tickets componentsJoinedByString:@","],[seats componentsJoinedByString:@","]];
}

-(void)dealloc{
    seclectSeatView = nil;
    header_view = nil;
    
    
}

@end









