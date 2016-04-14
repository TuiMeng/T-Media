//
//  MSelectPayTypeCell.h
//  推盟
//
//  Created by joinus on 16/3/17.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  支付方式
 */

#import <UIKit/UIKit.h>

typedef void(^mSelectPayTypeCellBlock)(UIButton * button,id cell);

@interface MSelectPayTypeCell : UITableViewCell{
    mSelectPayTypeCellBlock selectPayTypeBlock;
}

@property(nonatomic,strong)UIImageView  *   headerImageView;

@property(nonatomic,strong)UILabel      *   titleLabel;

@property(nonatomic,strong)UILabel      *   subTitleLabel;

@property(nonatomic,strong)UIButton     *   selectButton;


-(void)selectedBlock:(mSelectPayTypeCellBlock)block;



@end
