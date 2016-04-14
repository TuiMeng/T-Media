//
//  InvitationTableViewCell.m
//  推盟
//
//  Created by joinus on 15/8/26.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "InvitationTableViewCell.h"

@implementation InvitationTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _phone_num_label = [ZTools createLabelWithFrame:CGRectMake(10, 7, 90, 30) tag:10 text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:15];
        [self.contentView addSubview:_phone_num_label];
        
        _user_name_label = [ZTools createLabelWithFrame:CGRectMake(_phone_num_label.right+10, 7, DEVICE_WIDTH-220, 30) tag:11 text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:15];
        [self.contentView addSubview:_user_name_label];
        
        _date_label = [ZTools createLabelWithFrame:CGRectMake(_user_name_label.right+10, 7, DEVICE_WIDTH-_user_name_label.right-20, 30) tag:10 text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight font:15];
        [self.contentView addSubview:_date_label];
        
        UIImageView * line_view = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.height-0.5, DEVICE_WIDTH-20, 0.5)];
        line_view.image = [UIImage imageNamed:@"root_line_view"];
        [self.contentView addSubview:line_view];
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfomationWith:(NSDictionary *)dic{
    _phone_num_label.text = [ZTools returnEncryptionMobileNumWith:[dic objectForKey:@"new_phone"]];
    _user_name_label.text = dic[@"new_name"];
    _date_label.text = [ZTools timechangeWithTimestamp:dic[@"startdata"] WithFormat:@"YYYY-MM-dd"];
}

@end
