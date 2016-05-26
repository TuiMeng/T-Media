//
//  RootMovieView.h
//  推盟
//
//  Created by joinus on 16/3/2.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  推电影频道视图
 */
#import <UIKit/UIKit.h>
//type（1：详情 2：购票 3：悬赏 4：话题）
typedef void(^RootMovieViewBlock)(int type);

typedef void(^RootMovieShowNavigationViewBlock)(BOOL isShow);


@interface RootMovieView : UIView<SNRefreshDelegate,UITableViewDataSource>{
    RootMovieViewBlock movieView_block;
    RootMovieShowNavigationViewBlock RootUpDownBlock;
}

@property(nonatomic,strong)UIViewController     * viewController;

@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)SView               * top_view;

@property(nonatomic,strong)NSMutableArray   * data_array;

-(void)loadMoiveData;

-(void)setNavigationViewShow:(RootMovieShowNavigationViewBlock)block;

@end
