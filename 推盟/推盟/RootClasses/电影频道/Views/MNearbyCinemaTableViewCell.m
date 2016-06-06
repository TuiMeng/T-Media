//
//  MNearbyCinemaTableViewCell.m
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MNearbyCinemaTableViewCell.h"

@implementation MNearbyCinemaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_distance_label) {
            _distance_label = [ZTools createLabelWithFrame:CGRectMake(DEVICE_WIDTH-65, 15, 50, 30)
                                                      text:@""
                                                 textColor:RGBCOLOR(125, 125, 125)
                                             textAlignment:NSTextAlignmentRight
                                                      font:10];
            [self.contentView addSubview:_distance_label];
        }
        
        if (!_cinema_name_label) {
            _cinema_name_label = [ZTools createLabelWithFrame:CGRectMake(15, 10, DEVICE_WIDTH-30-_distance_label.width-20, 18)
                                                         text:@""
                                                    textColor:RGBCOLOR(31, 31, 31)
                                                textAlignment:NSTextAlignmentLeft
                                                         font:15];
            [self.contentView addSubview:_cinema_name_label];
        }
        
        if (!_address_label) {
            _address_label = [ZTools createLabelWithFrame:CGRectMake(15, _cinema_name_label.bottom+5, _cinema_name_label.width, 15)
                                                     text:@""
                                                textColor:RGBCOLOR(125, 125, 125)
                                            textAlignment:NSTextAlignmentLeft
                                                     font:12];
            [self.contentView addSubview:_address_label];
        }
        
        /*张少南
        
        if (!_starRatingView) {
            _starRatingView = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(13, 13) numberOfStars:5 rating:3.5 fillColor:RGBCOLOR(253, 180, 90) unfilledColor:[UIColor clearColor] strokeColor:RGBCOLOR(253, 180, 90)];
            _starRatingView.padding = 2;
            _starRatingView.top = _address_label.bottom+2;
            _starRatingView.left = 15;
            [self.contentView addSubview:_starRatingView];
        }
        
        if (!_price_label) {
            _price_label = [ZTools createLabelWithFrame:CGRectMake(_starRatingView.right+10, _starRatingView.top, DEVICE_WIDTH-30-_distance_label.width-20, 16) text:@"￥33.5起" textColor:RGBCOLOR(251, 75, 78) textAlignment:NSTextAlignmentLeft font:15];
            [self.contentView addSubview:_price_label];
        }
        */
        /*
        if (!_play_time_label) {
            _play_time_label = [ZTools createLabelWithFrame:CGRectMake(15, _address_label.bottom+5, DEVICE_WIDTH-30-_distance_label.width-20, 16)
                                                       text:@""
                                                  textColor:RGBCOLOR(125, 125, 125)
                                              textAlignment:NSTextAlignmentLeft
                                                       font:12];
            [self.contentView addSubview:_play_time_label];
        }
         */
        
    }
    return self;
}


-(void)setInfomationWithCinemasModel:(MLocationCinemasModel *)model{
    _cinema_name_label.text     = model.cinemaName;
    _address_label.text         = model.cinemaAddr;
    _distance_label.text        = model.distance.intValue?model.distance:@"";
//    _play_time_label.text       = [NSString stringWithFormat:@"近期场次：%@",model.plans.length?model.plans:@"当天无"];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
