//
//  PrizeListView.h
//  推盟
//
//  Created by joinus on 16/6/3.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrizeListView : UIView

@property(nonatomic,strong)UIViewController     * viewController;
@property(nonatomic,strong)NSMutableArray       * dataArray;


-(void)getData;

@end
