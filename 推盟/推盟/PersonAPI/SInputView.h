//
//  SInputView.h
//  推盟
//
//  Created by joinus on 16/3/28.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SInputViewSendBlock)(void);

@interface SInputView : SView{
    SInputViewSendBlock sendBlock;
}

@property(nonatomic,strong)STextField      * textField;
@property(nonatomic,strong)UIButton         * sendButton;




-(void)setSendBlock:(SInputViewSendBlock)block;







@end






















