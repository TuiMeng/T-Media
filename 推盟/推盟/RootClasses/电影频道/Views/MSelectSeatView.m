//
//  MSelectSeatView.m
//  推盟
//
//  Created by joinus on 16/3/10.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MSelectSeatView.h"
#import "SMScrollView.h"
#import "KyoCenterLineView.h"
#import "KyoRowIndexView.h"


#define kRowIndexWith   16.0
#define kRowIndexSpace  5.0
#define kRowIndexViewDefaultColor   [RGBCOLOR(162,162,162) colorWithAlphaComponent:0.5]
#define kCenterLineViewTail 6.0


@interface MSelectSeatView ()<SMCinameSeatScrollViewDelegate,UIScrollViewDelegate>{
    //预览图显示时间
    NSTimer * preViewTimer;
    int     preViewCount;
}

@property (nonatomic, assign)  NSUInteger row;
@property (nonatomic, assign)  NSUInteger column;
@property (nonatomic, assign)  CGSize seatSize;
@property (assign, nonatomic)  CGFloat seatTop;
@property (assign, nonatomic)  CGFloat seatLeft;
@property (assign, nonatomic)  CGFloat seatBottom;
@property (assign, nonatomic)  CGFloat seatRight;
@property (strong, nonatomic)  UIImage *imgSeatNormal;
@property (strong, nonatomic)  UIImage *imgSeatHadBuy;
@property (strong, nonatomic)  UIImage *imgSeatSelected;
@property (strong, nonatomic)  UIImage *imgSeatUnexist;
@property (strong, nonatomic)  UIImage *imgSeatLoversLeftNormal;
@property (strong, nonatomic)  UIImage *imgSeatLoversLeftHadBuy;
@property (strong, nonatomic)  UIImage *imgSeatLoversLeftSelected;
@property (strong, nonatomic)  UIImage *imgSeatLoversRightNormal;
@property (strong, nonatomic)  UIImage *imgSeatLoversRightHadBuy;
@property (strong, nonatomic)  UIImage *imgSeatLoversRightSelected;

@property (assign, nonatomic)  BOOL                 showCenterLine;
@property (assign, nonatomic)  BOOL                 showRowIndex;
@property (assign, nonatomic)  BOOL                 rowIndexStick;  /**< 是否让showIndexView粘着左边 */
@property (strong, nonatomic)  UIColor              * rowIndexViewColor;
@property (assign, nonatomic)  NSInteger            rowIndexType; //座位左边行号提示样式
@property (strong, nonatomic)  NSArray              * arrayRowIndex; //座位号左边行号提示（用它则忽略

@property (strong, nonatomic) UIView                * contentView;
@property (strong, nonatomic) UIView                * seatsView;
@property (strong, nonatomic) KyoRowIndexView       * rowIndexView;
@property (strong, nonatomic) KyoCenterLineView     * centerLineView;

@property (strong, nonatomic) NSMutableDictionary   * dictSeat;

@property(strong,  nonatomic) NSMutableArray        * selectedArray;

@property (retain, nonatomic) SMScrollView          * myScrollView;

@property(nonatomic,strong)UIButton                 * cinema_screen_button;
@property(nonatomic,strong)UILabel                  * screen_center_label;
//预览图
@property(nonatomic,strong)UIImageView              * preView;
//提示框
@property(nonatomic,strong)UIImageView              * PromptBoxImageView;


@end


@implementation MSelectSeatView


-(id)initWithFrame:(CGRect)frame WithSeatArray:(NSMutableArray *)seats{
    self = [super initWithFrame:frame];
    if (self) {
        _seatArray = seats;
        _selectedArray = [NSMutableArray array];
        [self setMainView];
    }
    return self;
}

-(void)setSeatArray:(NSMutableArray *)seatArray{
    _seatArray = seatArray;
    _row = seatArray.count;
    if (seatArray.count > 0) {
        _column = [seatArray[0] count];
    }
    self.myScrollView.contentSize = CGSizeMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) * _myScrollView.zoomScale,(self.seatTop + self.row * self.seatSize.height + self.seatBottom) * _myScrollView.zoomScale);
    
    [self showSeatCenter];

    [self drawSeat];
}

-(void)selectSeatClicked:(MselectSeatDidSelectedBlock)block{
    selectedSeatBlock = block;
}

-(void)setMainView{
    _row = _seatArray.count;
    if (_seatArray.count > 0) {
        _column = [_seatArray[0] count];
        if (_column%2 != 0) {
            _column += 1;
        }
    }
    
    
    int rowNum = 1;
    NSMutableArray * rowNumArray = [NSMutableArray array];
    for (NSMutableArray * obj in _seatArray) {
        if ([obj count]) {
            [rowNumArray addObject:[NSString stringWithFormat:@"%d",rowNum]];
        }else{
            rowNum--;
            [rowNumArray addObject:@""];
        }
        rowNum++;
    }
    self.arrayRowIndex = [NSArray arrayWithArray:rowNumArray];
    
    _seatTop = 65;
    _seatLeft = kRowIndexWith+kRowIndexSpace+5;
    _seatBottom = 20;
    _seatRight = _seatLeft;
    _seatSize = CGSizeMake(30, 30);
    _myScrollView.zoomScale = 1.0;
    
    _imgSeatNormal = [UIImage imageNamed:@"m_seat_unselected_image"];
    _imgSeatHadBuy = [UIImage imageNamed:@"m_seat_hadBuy_image"];
    _imgSeatSelected = [UIImage imageNamed:@"m_seat_selected_image"];
    
    
    _showCenterLine = YES;
    _showRowIndex = YES;
    _rowIndexStick = YES;
    
    self.myScrollView = [[SMScrollView alloc] init];
    _myScrollView.contentSize = CGSizeMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) * _myScrollView.zoomScale,(self.seatTop + self.row * self.seatSize.height + self.seatBottom) * _myScrollView.zoomScale);
    
    NSLog(@"_myScrollView.contentSize = %@",NSStringFromCGRect(_myScrollView.frame));
    NSLog(@"_myScrollView.zoomScale = %f",_myScrollView.zoomScale);
    if (!self.contentView) {
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if (!self.seatsView) {
        self.seatsView =[[UIView alloc] init];
        self.seatsView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.seatsView];
    }
    
    _contentView.frame = CGRectMake(0, 0, _myScrollView.contentSize.width, _myScrollView.contentSize.height);
    self.seatsView.frame = _contentView.bounds;
    
    _contentView.contentMode = UIViewContentModeScaleAspectFill;
    _contentView.clipsToBounds = YES;
    _SMCinameSeatScrollViewDelegate = self;
    
    self.myScrollView = [[SMScrollView alloc] initWithFrame:self.bounds];
    self.myScrollView.maximumZoomScale = 2;
    self.myScrollView.delegate = self;
    self.myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myScrollView.contentSize = _contentView.frame.size;
    self.myScrollView.alwaysBounceVertical = YES;
    self.myScrollView.alwaysBounceHorizontal = YES;
    self.myScrollView.stickToBounds = YES;
    [self.myScrollView addViewForZooming:_contentView];
    [self.myScrollView scaleToFit];
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.myScrollView];
    
    self.myScrollView.contentSize = CGSizeMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) * _myScrollView.zoomScale,(self.seatTop + self.row * self.seatSize.height + self.seatBottom) * _myScrollView.zoomScale);
    
    
    //画座位
    [self drawSeat];
    
    UIImageView *seatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 50, 50)];
    seatImageView.image = [UIImage imageNamed:@"selectSeat"];
    [_contentView addSubview:seatImageView];
    [_contentView bringSubviewToFront:seatImageView];
    
    
    
    //画座位行数提示
    if (!self.rowIndexView) {
        self.rowIndexView                   = [[KyoRowIndexView alloc] init];
        self.rowIndexView.backgroundColor   = self.rowIndexViewColor ? : kRowIndexViewDefaultColor;
        [_contentView addSubview:self.rowIndexView];
    }
    if (self.showRowIndex) {
        [_contentView bringSubviewToFront:self.rowIndexView];
        [_myScrollView bringSubviewToFront:self.rowIndexView];
        self.rowIndexView.row               = self.row;
        self.rowIndexView.width             = kRowIndexWith;
        self.rowIndexView.rowIndexViewColor = self.rowIndexViewColor;
        
        self.rowIndexView.frame             = CGRectMake((kRowIndexSpace + (self.rowIndexStick ? _myScrollView.contentOffset.x : 0)) / _myScrollView.zoomScale, self.seatTop, kRowIndexWith, self.row * self.seatSize.height);
        
        NSLog(@"self.rowIndexView.frame = %@",NSStringFromCGRect(self.rowIndexView.frame));
        self.rowIndexView.rowIndexType      = self.rowIndexType;
        self.rowIndexView.arrayRowIndex     = self.arrayRowIndex;
        self.rowIndexView.hidden            = NO;
    } else {
        self.rowIndexView.hidden            = YES;
    }
    
    //画中线
    if (!self.centerLineView) {
        self.centerLineView = [[KyoCenterLineView alloc] init];
        self.centerLineView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.centerLineView];
    }
    if (self.showCenterLine) {
        [self.contentView bringSubviewToFront:self.centerLineView];
        if (self.showRowIndex) {
            self.centerLineView.frame = CGRectMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) / 2 + kRowIndexSpace * 2, self.seatTop, 1, self.row * self.seatSize.height + kCenterLineViewTail * 2);
        } else {
            self.centerLineView.frame = CGRectMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) / 2, self.seatTop - kCenterLineViewTail, 1, self.row * self.seatSize.height + kCenterLineViewTail * 2);
        }
        
        if (self.row > 0 && self.column > 0) {
            self.centerLineView.hidden = NO;
        } else {
            self.centerLineView.hidden = YES;
        }
    } else {
        self.centerLineView.hidden = YES;
    }
    
    //屏幕位置
    if (!_cinema_screen_button) {
        _cinema_screen_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _cinema_screen_button.frame = CGRectMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) / 2 - 90, 0, 180, 18);
        CGRect center_line_rect = [_contentView convertRect:_centerLineView.frame toView:self];
        _cinema_screen_button.center = CGPointMake(center_line_rect.origin.x+center_line_rect.size.width/2.0f, 9);
        [_cinema_screen_button setBackgroundImage:[UIImage imageNamed:@"cinema_screen_image"] forState:UIControlStateNormal];
        [_cinema_screen_button setTitle:@"屏幕位置" forState:UIControlStateNormal];
        [_cinema_screen_button setTitleColor:RGBCOLOR(31, 31, 31) forState:UIControlStateNormal];
        _cinema_screen_button.enabled = NO;
        _cinema_screen_button.titleLabel.font = [ZTools returnaFontWith:12];
        [self addSubview:_cinema_screen_button];
    }
    
    if (!_screen_center_label) {
        _screen_center_label = [[UILabel alloc] initWithFrame:CGRectMake(0, _centerLineView.top-20, 50, 15)];
        _screen_center_label.center = CGPointMake(_cinema_screen_button.center.x, _screen_center_label.center.y);
        _screen_center_label.text = @"银幕中央";
        _screen_center_label.textColor = RGBCOLOR(173, 173, 173);
        _screen_center_label.layer.masksToBounds = YES;
        _screen_center_label.layer.cornerRadius = 2;
        _screen_center_label.layer.borderColor = RGBCOLOR(173, 173, 173).CGColor;
        _screen_center_label.layer.borderWidth = 0.5;
        _screen_center_label.textAlignment = NSTextAlignmentCenter;
        _screen_center_label.font = [ZTools returnaFontWith:10];
        [_contentView addSubview:_screen_center_label];
    }
    
    
    [self showSeatCenter];
    
    //加载预览图
    [self createPreView];
}

-(void)createPreView{
    if (!_preView) {
        _preView                    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 65)];
        _preView.backgroundColor    = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _preView.image = [ZTools shotScreenWithView:_seatsView size:_seatsView.frame.size scale:1];
        _preView.clipsToBounds      = YES;
        [self addSubview:_preView];
        _PromptBoxImageView         = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [ZTools autoWidthWith:134/2.0f], [ZTools autoWidthWith:104/2.0f])];
        _PromptBoxImageView.image   = [UIImage imageNamed:@"m_select_seats_promptBox_image"];
        [_preView addSubview:_PromptBoxImageView];
    }
    
    float w_scale                   = DEVICE_WIDTH/_myScrollView.contentSize.width;
    float h_scale                   = _myScrollView.height/_myScrollView.contentSize.height;
    _PromptBoxImageView.frame       = CGRectMake(_myScrollView.contentOffset.x*(_preView.width/_myScrollView.viewForZooming.width),
                                                 _myScrollView.contentOffset.y*(_preView.height/_myScrollView.viewForZooming.height),
                                                 _preView.width*w_scale,
                                                 _preView.height*h_scale);
    
    [self preViewShow];
    [self addTimer];
}


-(void)preViewShow{
    _preView.alpha = 1;
}
-(void)preViewHidden{
    [UIView animateWithDuration:0.3f animations:^{
        _preView.alpha  = 0;
    } completion:^(BOOL finished) {
        
    }];
}


//画座位
- (void)drawSeat{
    if (!self.dictSeat){
        self.dictSeat = [NSMutableDictionary dictionary];
    }
    
    CGFloat x = self.seatLeft + (self.showRowIndex ? kRowIndexSpace * 2 : 0);
    CGFloat y = self.seatTop;
    
    for (int row = 0; row < _seatArray.count; row++) {
        NSMutableArray * columArray = [_seatArray objectAtIndex:row];
        for (int column = 0; column < columArray.count; column++) {
            SeatModel * model   = columArray[column];
            model.row           = row;
            model.column        = column;
            KyoButton * btnSeat = nil;
            
            btnSeat                 = [KyoButton buttonWithType:UIButtonTypeCustom];
            btnSeat.frame           = CGRectMake(x, y, self.seatSize.width, self.seatSize.height);
            btnSeat.tag             = row*_seatArray.count+column+100;
            btnSeat.row             = row;
            btnSeat.column          = column;
            btnSeat.adjustsImageWhenHighlighted   = NO;
            btnSeat.currentState    = [self getStateWithSeatState:model.seatStatus withButton:btnSeat];
            [btnSeat setImage:[self getSeatImageWithState:btnSeat.currentState] forState:UIControlStateNormal];
            [btnSeat addTarget:self action:@selector(buttonSeatClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_seatsView addSubview:btnSeat];
            
            x += self.seatSize.width;
            
            [self.dictSeat setObject:btnSeat forKey:@(btnSeat.tag)];
        }
        
        y += self.seatSize.height;
        x = self.seatLeft + (self.showRowIndex ? kRowIndexSpace * 2 : 0);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (_cinema_screen_button) {
        CGRect center_line_rect = [_contentView convertRect:_centerLineView.frame toView:self];
        _cinema_screen_button.center = CGPointMake(center_line_rect.origin.x+center_line_rect.size.width/2.0f, _cinema_screen_button.center.y);

    }
//    [self createPreView];
    return self.myScrollView.viewForZooming;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark --------------------
#pragma mark - Methods

//根据座位类型返回实际图片
- (UIImage *)getSeatImageWithState:(KyoCinameSeatState)state {
    if (state == KyoCinameSeatStateHadBuy) {
        return self.imgSeatHadBuy;
    } else if (state == KyoCinameSeatStateNormal) {
        return self.imgSeatNormal;
    } else if (state == KyoCinameSeatStateSelected) {
        return self.imgSeatSelected;
    } else if (state == KyoCinameSeatStateUnexist) {
        return self.imgSeatUnexist;
    } else if (state == KyoCinameSeatStateLoversLeftNormal) {
        return self.imgSeatLoversLeftNormal;
    } else if (state == KyoCinameSeatStateLoversLeftHadBuy) {
        return self.imgSeatLoversLeftHadBuy;
    } else if (state == KyoCinameSeatStateLoversLeftSelected) {
        return self.imgSeatLoversLeftSelected;
    } else if (state == KyoCinameSeatStateLoversRightNormal) {
        return self.imgSeatLoversRightNormal;
    } else if (state == KyoCinameSeatStateLoversRightHadBuy) {
        return self.imgSeatLoversRightHadBuy;
    } else if (state == KyoCinameSeatStateLoversRightSelected) {
        return self.imgSeatLoversRightSelected;
    } else {
        return self.imgSeatNormal;
    }
}

-(KyoCinameSeatState)getStateWithSeatState:(NSString*)state withButton:(UIButton*)button{
    
    int seatState = state.intValue;
    
    KyoCinameSeatState kyoState;
    
    switch (seatState) {
        case 0:
            kyoState = KyoCinameSeatStateUnexist;
            button.hidden = YES;
            break;
        case 1:
            kyoState = KyoCinameSeatStateHadBuy;
            button.userInteractionEnabled = NO;
            break;
        case 2:
            kyoState = KyoCinameSeatStateNormal;
            break;
        case 3:
            kyoState = KyoCinameSeatStateHadBuy;
            button.userInteractionEnabled = NO;
            break;
        case 4:
            kyoState = KyoCinameSeatStateHadBuy;
            button.userInteractionEnabled = NO;
            break;
            
        default:
            break;
    }
    
    return kyoState;
}

- (void)setNeedsDisplay {
    //[super setNeedsDisplay];
    
    if (self.rowIndexView) {
        [self.rowIndexView setNeedsDisplay];
    }
    
    if (self.centerLineView) {
        [self.centerLineView setNeedsDisplay];
    }
}

#pragma mark --------------------
#pragma mark - Events
- (void)btnSeatTouchIn:(UIButton *)btn {
    
    NSLog(@"btnSeatTouchIn-btn.tag=%ld",(long)btn.tag);
    if (self.SMCinameSeatScrollViewDelegate &&
        [self.SMCinameSeatScrollViewDelegate respondsToSelector:@selector(kyoCinameSeatScrollViewDidTouchInSeatWithRow:withColumn:)]) {
        
        NSArray *arraySeat = self.dictSeat[@(btn.tag)];
        NSUInteger column = [arraySeat indexOfObject:btn];
        [self.SMCinameSeatScrollViewDelegate kyoCinameSeatScrollViewDidTouchInSeatWithRow:btn.tag withColumn:column];
        
        [self drawSeat];
        [self setNeedsDisplay];
    }
}

-(void)buttonSeatClicked:(KyoButton*)button{
    
    if (_selectedArray.count >= 5 && button.currentState != KyoCinameSeatStateSelected) {
        [ZTools showMBProgressWithText:@"一次最多购买5张票" WihtType:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow isAutoHidden:YES];
        return;
    }
    
    if (button.currentState == KyoCinameSeatStateNormal) {
        button.currentState = KyoCinameSeatStateSelected;
        [button setImage:_imgSeatSelected forState:UIControlStateNormal];
        [_selectedArray addObject:_seatArray[button.row][button.column]];
    } else if (button.currentState == KyoCinameSeatStateSelected) {
        button.currentState = KyoCinameSeatStateNormal;
        [button setImage:_imgSeatNormal forState:UIControlStateNormal];
        [_selectedArray removeObject:_seatArray[button.row][button.column]];
    } else if (button.currentState == KyoCinameSeatStateHadBuy || button.currentState == KyoCinameSeatStateUnexist) {
        return;
    }
    
    selectedSeatBlock(_seatArray[button.row][button.column]);
    
    _preView.image = [ZTools shotScreenWithView:_seatsView size:_seatsView.frame.size scale:1];
}

#pragma mark -------------   删除选座
-(void)deleteSeatWithSeatModel:(SeatModel *)model{
    NSInteger tag = model.row*_seatArray.count+model.column+100;
    KyoButton * button = [_dictSeat objectForKey:@(tag)];
    [self buttonSeatClicked:button];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //画座位行数提示
    if (!self.rowIndexView) {
        self.rowIndexView = [[KyoRowIndexView alloc] init];
        self.rowIndexView.backgroundColor = self.rowIndexViewColor ? : kRowIndexViewDefaultColor;
        [_myScrollView addSubview:self.rowIndexView];
    }
    if (self.showRowIndex) {
        [_contentView bringSubviewToFront:self.rowIndexView];
        [_myScrollView bringSubviewToFront:self.rowIndexView];
        self.rowIndexView.row = self.row;
        self.rowIndexView.width = kRowIndexWith;
        self.rowIndexView.rowIndexViewColor = self.rowIndexViewColor;
        
        self.rowIndexView.frame = CGRectMake((kRowIndexSpace + (self.rowIndexStick ? _myScrollView.contentOffset.x : 0)) < 2 ? 2:(kRowIndexSpace + (self.rowIndexStick ? _myScrollView.contentOffset.x : 0)) / _myScrollView.zoomScale, self.seatTop,
                                             kRowIndexWith,
                                             self.row * self.seatSize.height);
        
//        NSLog(@"self.rowIndexView.frame = %@",NSStringFromCGRect(self.rowIndexView.frame));
//        NSLog(@"self.myScrollView.contentSize = %@",NSStringFromCGSize( _myScrollView.contentSize));
        
        self.rowIndexView.rowIndexType = self.rowIndexType;
        self.rowIndexView.arrayRowIndex = self.arrayRowIndex;
        self.rowIndexView.hidden = NO;
    } else {
        self.rowIndexView.hidden = YES;
    }
    
    if (_cinema_screen_button) {
        CGRect center_line_rect = [_contentView convertRect:_centerLineView.frame toView:self];
        _cinema_screen_button.center = CGPointMake(center_line_rect.origin.x+center_line_rect.size.width/2.0f, _cinema_screen_button.center.y);
    }
    
    [self createPreView];
    
    preViewCount = 0;
}

-(void)addTimer{
    if (!preViewTimer) {
        preViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:preViewTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)timeDown{
    preViewCount++;
    if (preViewCount == 3) {
        [self preViewHidden];
    }
}

-(void)showSeatCenter{
    
    NSLog(@"------- %@ ----  %f",NSStringFromCGSize(_myScrollView.contentSize),DEVICE_WIDTH);
    
    NSLog(@"y ------  %f",_myScrollView.contentOffset.x);
}

@end





