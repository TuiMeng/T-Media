//
//  CinemaSessionsTableViewCell.m
//  推盟
//
//  Created by joinus on 16/3/8.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "CinemaSessionsTableViewCell.h"
#define INDENT 15

@implementation CinemaSessionsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_start_time_label) {
            _start_time_label = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 70, 18) text:@"17:55" textColor:RGBCOLOR(31, 31, 31) textAlignment:NSTextAlignmentLeft font:15];
            [self.contentView addSubview:_start_time_label];
        }
        
        if (!_end_time_label) {
            _end_time_label = [ZTools createLabelWithFrame:CGRectMake(INDENT, _start_time_label.bottom+10, _start_time_label.width, 16) text:@"" textColor:DEFAULT_LINE_COLOR textAlignment:NSTextAlignmentLeft font:12];
            [self.contentView addSubview:_end_time_label];
        }
        
        if (!_language_label) {
            _language_label = [ZTools createLabelWithFrame:CGRectMake(_start_time_label.right+10, INDENT, 70, 18) text:@"国语3D" textColor:RGBCOLOR(31, 31, 31) textAlignment:NSTextAlignmentLeft font:15];
            [self.contentView addSubview:_language_label];
        }
        
        if (!_address_label) {
            _address_label = [ZTools createLabelWithFrame:CGRectMake(_language_label.left, _language_label.bottom+10, _language_label.width, 16) text:@"3号厅" textColor:DEFAULT_LINE_COLOR textAlignment:NSTextAlignmentLeft font:12];
            [self.contentView addSubview:_address_label];
        }
        
        if (!_price_label) {
            _price_label = [ZTools createLabelWithFrame:CGRectMake(DEVICE_WIDTH-180, INDENT, 80, 40) text:@"33.5元" textColor:DEFAULT_BACKGROUND_COLOR textAlignment:NSTextAlignmentRight font:18];
            [self.contentView addSubview:_price_label];
        }
        
        if (!_selected_seat_button) {
            _selected_seat_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-80, 22.5, 60, 25) title:@"选座购票" image:nil];
            _selected_seat_button.backgroundColor = [UIColor whiteColor];
            _selected_seat_button.titleLabel.font = [ZTools returnaFontWith:13];
            [_selected_seat_button setTitleColor:DEFAULT_BACKGROUND_COLOR forState:UIControlStateNormal];
            _selected_seat_button.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
            _selected_seat_button.layer.borderWidth = 1;
            _selected_seat_button.layer.cornerRadius = 3;
            [_selected_seat_button addTarget:self action:@selector(selectSeatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_selected_seat_button];
        }
    }
    
    return self;
}

-(void)selectSeatButtonClicked:(UIButton*)button{
    cell_block(self);
}

-(void)setInfomationWithMovieSequencesModel:(MovieSequencesModel *)model{
    _start_time_label.text  = model.seqTime;
    _language_label.text    = model.language;
    _address_label.text     = model.hallName;
    _price_label.text       = model.price;
}

-(void)selectSeatBlock:(CinemaSessionTableViewCellBlock)block{
    cell_block = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end






