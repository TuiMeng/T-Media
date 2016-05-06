//
//  SListTopBarScrollView.m
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "SListTopBarScrollView.h"
#define kStatusHeight 20
#define padding 20
#define itemPerLine 4
#define kItemW (kScreenW-padding*(itemPerLine+1))/itemPerLine
#define kItemH 25


#define kDistanceBetweenItem 32
#define kExtraPadding 20
#define itemFont 15


@interface SListTopBarScrollView ()

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) UIView *btnBackView;
@property(nonatomic,strong)UIView * bottom_line_view;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) NSMutableArray *btnLists;


@end

@implementation SListTopBarScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(NSMutableArray *)btnLists{
    if (_btnLists == nil) {
        _btnLists = [NSMutableArray array];
    }
    return _btnLists;
}

-(void)setVisibleItemList:(NSMutableArray *)visibleItemList{
    
    _visibleItemList = visibleItemList;
    
    
    if (!self.bottom_line_view) {
        self.bottom_line_view = [[UIView alloc] initWithFrame:CGRectMake(10, self.height-1,self.lineWidth, 1)];
        self.bottom_line_view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        [self addSubview:self.bottom_line_view];
    }
    
    if (!self.btnBackView) {
        self.btnBackView = [[UIView alloc] initWithFrame:CGRectMake(10,(self.frame.size.height-20)/2,46,20)];
        self.btnBackView.backgroundColor = RGBCOLOR(202.0, 51.0, 54.0);
        self.btnBackView.layer.cornerRadius = 5;
        self.maxWidth = 20;
        self.backgroundColor = DEFAULT_LIGHT_BLACK_COLOR;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
        self.showsHorizontalScrollIndicator = NO;
        for (int i =0; i<visibleItemList.count; i++) {
            [self makeItemWithTitle:visibleItemList[i] withFrame:CGRectMake(self.btnWidth*i, 0,self.btnWidth, self.frame.size.height)];
        }
        
//        if (visibleItemList.count > 4) {
            self.contentSize = CGSizeMake(self.btnWidth*visibleItemList.count-50, self.frame.size.height);
//        }else{
//            self.contentSize = CGSizeMake(0, self.frame.size.height);
//        }
    }
}


-(void)makeItemWithTitle:(NSString *)title withFrame:(CGRect)frame{
//    CGFloat itemW = [self calculateSizeWithFont:itemFont Text:title].size.width;
    UIButton *item = [[UIButton alloc] initWithFrame:frame];
    item.titleLabel.font = _titleFont;
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitleColor:_titleNormalColor forState:UIControlStateNormal];
    [item setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
    
    [item addTarget:self
             action:@selector(itemClick:)
   forControlEvents:1 << 6];
    [self.btnLists addObject:item];
    [self addSubview:item];
    if (!self.btnSelect) {
        [item setTitleColor:_titleSelectedColor forState:UIControlStateNormal];
        self.btnSelect = item;
    }
}


-(void)itemClick:(UIButton *)sender{
    if (self.btnSelect != sender) {
        [self.btnSelect setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [sender setTitleColor:_titleSelectedColor forState:0];
        self.btnSelect = sender;
        
        if (self.listBarItemClickBlock) {
            self.listBarItemClickBlock(sender.titleLabel.text,[self findIndexOfListsWithTitle:sender.titleLabel.text]);
        }
    }
    
  
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottom_line_view.left = sender.left + 10;
        
    } completion:^(BOOL finished) {
        
        if (_visibleItemList.count <= 4) {
            return ;
        }
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint changePoint;
            if (sender.frame.origin.x >= DEVICE_WIDTH - 150 && sender.frame.origin.x < self.contentSize.width-200) {changePoint = CGPointMake(sender.frame.origin.x - 200, 0);}
            else if (sender.frame.origin.x >= self.contentSize.width-200){changePoint = CGPointMake(self.contentSize.width-350, 0);}
            else{changePoint = CGPointMake(0, 0);}
            self.contentOffset = changePoint;
        }];
    }];
}

-(void)itemClickByScrollerWithIndex:(NSInteger)index{
    UIButton *item = (UIButton *)self.btnLists[index];
    [self itemClick:item];
}
-(void)switchPositionWithItemName:(NSString *)itemName index:(NSInteger)index{
    UIButton *button = self.btnLists[[self findIndexOfListsWithTitle:itemName]];
    [self.visibleItemList removeObject:itemName];
    [self.btnLists removeObject:button];
    [self.visibleItemList insertObject:itemName atIndex:index];
    [self.btnLists insertObject:button atIndex:index];
    [self itemClick:self.btnSelect];
    [self resetFrame];
}

-(void)removeItemWithTitle:(NSString *)title{
    NSInteger index = [self findIndexOfListsWithTitle:title];
    UIButton *select_button = self.btnLists[index];
    [self.btnLists[index] removeFromSuperview];
    [self.btnLists removeObject:select_button];
    [self.visibleItemList removeObject:title];
}

-(NSInteger)findIndexOfListsWithTitle:(NSString *)title{
    for (int i =0; i < self.visibleItemList.count; i++) {
        if ([title isEqualToString:self.visibleItemList[i]]) {
            return i;
        }
    }
    return 0;
}

-(void)resetFrame{
    self.maxWidth = 20;
    for (int i = 0; i < self.visibleItemList.count; i++) {
        [UIView animateWithDuration:0.0001 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat itemW = [self calculateSizeWithFont:itemFont Text:self.visibleItemList[i]].size.width;
            [[self.btnLists objectAtIndex:i] setFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
            self.maxWidth += kDistanceBetweenItem + itemW;
        } completion:^(BOOL finished){
        }];
    }
}

-(CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
