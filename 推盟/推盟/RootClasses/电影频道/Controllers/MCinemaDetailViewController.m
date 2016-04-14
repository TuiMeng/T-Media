//
//  MCinemaDetailViewController.m
//  推盟
//
//  Created by joinus on 16/3/18.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MCinemaDetailViewController.h"
#import "CinemaCommentCell.h"

@interface MCinemaDetailViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * addressArray;

@end


@implementation MCinemaDetailViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"影院详情";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"发评论"];
    _dataArray = [NSMutableArray array];
    _addressArray = [NSMutableArray arrayWithObjects:@"海淀区上地南口华联商厦4F",@"18600755163",nil];
    
    
    for (int i = 0; i < 10; i++) {
        CinemaCommentModel * model = [[CinemaCommentModel alloc] init];
        model.userImage = @"http://imgsrc.baidu.com/forum/pic/item/4bed2e738bd4b31c3f51fb2887d6277f9e2ff830.jpg";
        model.userName = @"soulnear";
        model.date = @"2016-3-18 16:05";
        model.content = @"非常差，前十分钟都没有声音，还要补差价15坚决不会再来！服务员很差劲！建议都不要再来，这么多差评没看到后悔来了。有蚊子，超级差,哈哈哈";
        model.score = @"7";
        [_dataArray addObject:model];
    }
    
    
    [self setMainView];
    
}

-(void)setMainView{
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [self createHeaderView];
}

-(void)createHeaderView{
    
    SView * sectionView = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 90)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    CGSize nameSize = [ZTools stringHeightWithFont:[ZTools returnaFontWith:16] WithString:_cinema_model.cinemaName WithWidth:MAXFLOAT];
    UILabel * cinemaNameLabel = [ZTools createLabelWithFrame:CGRectMake(15, 15, nameSize.width, 20) text:_cinema_model.cinemaName textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:16];
    [sectionView addSubview:cinemaNameLabel];
    
    UILabel * scoreLabel = [ZTools createLabelWithFrame:CGRectMake(cinemaNameLabel.right + 5, cinemaNameLabel.top, 100, cinemaNameLabel.height) text:@"8.6分" textColor:DEFAULT_ORANGE_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    [sectionView addSubview:scoreLabel];
    
    DJWStarRatingView * starRatingView = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(20, 20) numberOfStars:5 rating:5 fillColor:STAR_FILL_COLOR unfilledColor:STAR_UNFILL_COLOR strokeColor:STAR_STROKE_COLOR];
    starRatingView.top = cinemaNameLabel.bottom + 5;
    starRatingView.left = 15 - starRatingView.padding;
    [sectionView addSubview:starRatingView];
    
    UILabel * commentCountLabel = [ZTools createLabelWithFrame:CGRectMake(starRatingView.right+5, starRatingView.top, DEVICE_WIDTH-starRatingView.right-30,starRatingView.height) text:@"4555人评分" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
    [sectionView addSubview:commentCountLabel];
    
    UIView * separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, commentCountLabel.bottom+10, DEVICE_WIDTH, 10)];
    separatorView.backgroundColor = RGBCOLOR(245, 245, 245);
    [sectionView addSubview:separatorView];
    
    sectionView.height = separatorView.bottom;

    //地址+电话
    if (_addressArray.count) {
        SView * addressAndPhoneView = [[SView alloc] initWithFrame:CGRectMake(0, separatorView.bottom, DEVICE_WIDTH, 0)];
        [sectionView addSubview:addressAndPhoneView];
        
        BOOL showAddress = NO;
        BOOL showPhone = NO;
        
        if ([[ZTools replaceNullString:_cinema_model.cinemaAddr WithReplaceString:@""] length] != 0) {
            showAddress = YES;
            UIView * addressView = [self createInfoBackgroundViewWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50) WithImage:[UIImage imageNamed:@"cinema_location_image"] WithTitle:_cinema_model.cinemaAddr WithTag:100];
            [addressAndPhoneView addSubview:addressView];
        }
        
        if (@"18600755163".length != 0) {
            if (showAddress) {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 50, DEVICE_WIDTH-15, 0.5)];
                lineView.backgroundColor = DEFAULT_LINE_COLOR;
                [addressAndPhoneView addSubview:lineView];
                
                addressAndPhoneView.height = 90;
            }else{
                addressAndPhoneView.height = 40;
            }
            
            showPhone = YES;
            
            UIView * phoneView = [self createInfoBackgroundViewWithFrame:CGRectMake(0, showAddress?50:0, DEVICE_WIDTH, 40) WithImage:[UIImage imageNamed:@"cinema_tel_image"] WithTitle:@"18600755163" WithTag:101];
            [addressAndPhoneView addSubview:phoneView];
        }
        
        if (showPhone || showAddress) {
            UIView * separatorView2 = [[UIView alloc]initWithFrame:CGRectMake(0, addressAndPhoneView.bottom, DEVICE_WIDTH, 10)];
            separatorView2.backgroundColor = RGBCOLOR(245, 245, 245);
            [sectionView addSubview:separatorView2];
            
            sectionView.height = separatorView2.bottom;
        }
    }
    
    _myTableView.tableHeaderView = sectionView;
}


#pragma mark ------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"idenifier";
    CinemaCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CinemaCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    CinemaCommentModel * model = _dataArray[indexPath.row];
    
    [cell setInfomationWithCinemaCommentModel:model];
    
    return cell;
}

- (void)loadNewData{

}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    CinemaCommentModel * model = _dataArray[indexPath.row];
    
    CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:14] WithString:model.content WithWidth:DEVICE_WIDTH-80];
    
    return 70 + size.height;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section{
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel * totalCountLabel = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-30, sectionView.height) text:[NSString stringWithFormat:@"用户评论（%lu条）",_dataArray.count] textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    [sectionView addSubview:totalCountLabel];
    
    return sectionView;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    return 40;
}


#pragma mark ----  创建地址 电话视图
-(UIView *)createInfoBackgroundViewWithFrame:(CGRect)frame WithImage:(UIImage *)image WithTitle:(NSString *)title WithTag:(int)tag{

    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.tag = tag;
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (frame.size.height-15)/2.0f, 15, 15)];
    leftImageView.image = image;
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:leftImageView];
    
    UIImage * arrowImage = [UIImage imageNamed:@"cinema_right_arrow_image"];
    UIImageView * rightImageView = [[UIImageView alloc] initWithImage:arrowImage];
    rightImageView.center = CGPointMake(DEVICE_WIDTH-arrowImage.size.width/2.0f-15, frame.size.height/2.0f);
    rightImageView.image = arrowImage;
    [view addSubview:rightImageView];
    
    UILabel * titleLabel = [ZTools createLabelWithFrame:CGRectMake(leftImageView.right+10, 5, rightImageView.left - leftImageView.right-20, frame.size.height-10) text:title textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:14];
    titleLabel.numberOfLines = 0;
    [view addSubview:titleLabel];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

-(void)doTap:(UITapGestureRecognizer*)sender{
    
    switch (sender.view.tag) {
        case 100:
            
            break;
        case 101:
            
            break;
            
        default:
            break;
    }
    
}


@end











