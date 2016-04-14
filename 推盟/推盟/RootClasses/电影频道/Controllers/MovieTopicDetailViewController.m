//
//  MovieTopicDetailViewController.m
//  推盟
//
//  Created by joinus on 16/3/28.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieTopicDetailViewController.h"
#import "TopicCommentCell.h"
#import "MTopicCommentModel.h"
#import "SInputView.h"


@interface MovieTopicDetailViewController ()<SNRefreshDelegate,UITableViewDataSource,UITextFieldDelegate>{
    float keyboardHeight;
}
@property(nonatomic,strong)SInputView           * inputView;
@property(nonatomic,strong)SNRefreshTableView   * myTableView;
@property(nonatomic,strong)NSMutableArray       * dataArray;


@end

@implementation MovieTopicDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"话题详情";
    _dataArray = [NSMutableArray array];
    
    
    [self setMainView];
    
    [self loadTopicCommentData];
    
    
}

-(void)setMainView{
    
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-45)];
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [self.view addSubview:_myTableView];
    
    _inputView                      = [[SInputView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-64-45, DEVICE_WIDTH, 45)];
    _inputView.textField.delegate   = self;
    [self.view addSubview:_inputView];
    
    [_inputView setSendBlock:^{
        
    }];
    
    [self createHeaderView];
}

-(void)createHeaderView{
    SView       * sectionView           = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    sectionView.lineColor               = DEFAULT_MOVIE_LINE_COLOR;
    
    UILabel     * titleLabel            = [ZTools createLabelWithFrame:CGRectMake(15, 15, DEVICE_WIDTH-30, 0) text:_topicModel.title textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:16];
    titleLabel.font                     = [UIFont boldSystemFontOfSize:16];
    titleLabel.numberOfLines            = 0;
    [titleLabel sizeToFit];
    [sectionView addSubview:titleLabel];
    
    UIImageView * headerImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLabel.bottom+10, 40, 40)];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius  = headerImageView.width/2.0f;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.zcool.cn/community/014d5c5621f7356ac72548787b7c58.jpg"] placeholderImage:nil];
    [sectionView addSubview:headerImageView];
    
    UILabel     * userNameLabel         = [ZTools createLabelWithFrame:CGRectMake(headerImageView.right+5, headerImageView.top, DEVICE_WIDTH-headerImageView.right-20, 18) text:@"推出一片天" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
    [sectionView addSubview:userNameLabel];
    
    UILabel     * dateLabel             = [ZTools createLabelWithFrame:CGRectMake(userNameLabel.left, userNameLabel.bottom+3, userNameLabel.width, 15) text:@"2016-3-28" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
    [sectionView addSubview:dateLabel];
    
    UILabel     * contentLabel          = [ZTools createLabelWithFrame:CGRectMake(15, headerImageView.bottom+10, DEVICE_WIDTH-30, 0) text:_topicModel.content textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    contentLabel.numberOfLines          = 0;
    [contentLabel sizeToFit];
    [sectionView addSubview:contentLabel];
    
    sectionView.height                  = contentLabel.bottom + 20;

    if (_topicModel.images.count) {
        UIImageView * imageView         = [[UIImageView alloc] initWithFrame:CGRectMake(15, contentLabel.bottom+10, DEVICE_WIDTH-30, 215)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_topicModel.images[0]] placeholderImage:nil];
        [sectionView addSubview:imageView];
        sectionView.height              = imageView.bottom + 20;
    }
    
    sectionView.isShowBottomLine = YES;
    _myTableView.tableHeaderView = sectionView;
}

-(void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo      = [notification userInfo];
    NSValue *aValue             = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect         = [aValue CGRectValue];
    keyboardHeight              = keyboardRect.size.height;
    
    if (_inputView.bottom != DEVICE_HEIGHT - 64 - keyboardHeight) {
        _inputView.bottom       = DEVICE_HEIGHT - 64 - keyboardHeight;
    }
}
-(void)keyBoardWillHidden:(NSNotification *)notification{
    if (_inputView.bottom != DEVICE_HEIGHT - 64) {
        _inputView.bottom       = DEVICE_HEIGHT - 64;
    }
}

#pragma mark ------  话题评论请求
-(void)loadTopicCommentData{
    
    for (int i = 0; i < 10; i++) {
        MTopicCommentModel * model      = [[MTopicCommentModel alloc] init];
        model.name                      = @"孙悟空";
        model.img                       = @"http://img5q.duitang.com/uploads/item/201501/26/20150126231940_YGGNT.png";
        int ao = arc4random()%2;
        model.content                   = [NSString stringWithFormat:@"%d交流电卡建档立卡刷机大师建档立卡就对啦肯定就简单快乐是骄傲的卡拉就对啦科技大楼开始就打了快圣诞节拉开的骄傲了肯德基阿拉看得见阿洛克的骄傲了肯德基几点开始垃圾堆里",ao];
        
        if (ao) {
            model.orginModel            = [[MTopicCommentOrginModel alloc] init];
            model.orginModel.name       = @"soulnear";
            model.orginModel.content    = @"桃花坞里桃花庵，桃花庵下桃花仙，桃花仙人种桃树，又摘桃花换酒钱，别人笑我太疯癫，我笑他人看不穿，不见五陵豪杰墓，无花无酒锄作田";
        }
        
        [_dataArray addObject:model];
    }
    
}

#pragma mark -------   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier    = @"identifier";
    TopicCommentCell * cell         = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell                        = [[TopicCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    MTopicCommentModel * model      = _dataArray[indexPath.row];
    
    [cell setInfomationWithTopicCommentModel:model];
    
    return cell;
}


-(void)loadNewData{
    
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    MTopicCommentModel * model = _dataArray[indexPath.row];
    CGSize contentSize = [ZTools stringHeightWithFont:[ZTools returnaFontWith:14] WithString:model.content WithWidth:(DEVICE_WIDTH-30)];
    float orginH = 0;
    if (model.orginModel) {
        orginH = 65;
    }
    
    return 75 + contentSize.height + orginH;
}

#pragma mark ------  UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *newValue = [textField.text mutableCopy];
    [newValue replaceCharactersInRange:range withString:string];
    
    if (newValue.length == 0) {
        _inputView.sendButton.enabled = NO;
    }else{
        _inputView.sendButton.enabled = YES;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)dealloc{
    
}


@end














