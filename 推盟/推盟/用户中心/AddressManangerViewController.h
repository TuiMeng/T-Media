//
//  AddressManangerViewController.h
//  推盟
//
//  Created by joinus on 16/6/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyViewController.h"
#import "UserInfoModel.h"

typedef void(^addressManangerSaveSuccessBlock)(UserAddressModel * model);

@interface AddressManangerViewController : MyViewController{
    addressManangerSaveSuccessBlock saveBlock;
}


-(void)save:(addressManangerSaveSuccessBlock)block;




@end
