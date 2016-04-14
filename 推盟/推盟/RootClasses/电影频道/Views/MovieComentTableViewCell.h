//
//  MovieComentTableViewCell.h
//  推盟
//
//  Created by joinus on 16/3/4.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  影评
 */

#import <UIKit/UIKit.h>
#import "MovieCommentsModel.h"

@interface MovieComentTableViewCell : UITableViewCell{
    
}


@property(nonatomic,strong)DJWStarRatingView * starRatingView;
@property(nonatomic,strong)UILabel * date_label;
@property(nonatomic,strong)UILabel * content_label;
@property(nonatomic,strong)UIImageView * header_imageView;
@property(nonatomic,strong)UILabel * user_name_label;


-(void)setInfomationWithMovieCommentsModel:(MovieCommentsModel*)model;

@end
