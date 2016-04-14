//
//  FriendListTableViewCell.m
//  推盟
//
//  Created by joinus on 15/12/29.
//  Copyright © 2015年 joinus. All rights reserved.
//

#import "FriendListTableViewCell.h"

@implementation FriendListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _user_name_label.adjustsFontSizeToFitWidth = YES;
    
    _user_name_label.font = [ZTools returnaFontWith:15];
    _user_phone_num_label.font = [ZTools returnaFontWith:15];
    _user_register_label.font = [ZTools returnaFontWith:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfomationWithFriendListModel:(FriendListModel *)model{
    _user_name_label.text = model.user_name;
    _user_phone_num_label.text = model.user_mobile;
    _user_register_label.text = model.register_date;
}

@end
