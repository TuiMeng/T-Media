//
//  SListTopBarScrollView.h
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SListTopBarScrollView : UIScrollView

@property (nonatomic,copy) void(^listBarItemClickBlock)(NSString *itemName , NSInteger itemIndex);

@property (nonatomic,strong) NSMutableArray *visibleItemList;

@property(nonatomic,strong)  UIColor * titleNormalColor;

@property(nonatomic,strong)  UIColor * titleSelectedColor;

@property(nonatomic,strong)  UIFont  * titleFont;

@property(nonatomic,assign)  float     btnWidth;

@property(nonatomic,assign)  float     lineWidth;

-(void)itemClickByScrollerWithIndex:(NSInteger)index;


@end
