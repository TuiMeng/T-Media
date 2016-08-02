//
//  AddressManangerViewController.m
//  推盟
//
//  Created by joinus on 16/6/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "AddressManangerViewController.h"
#import "AddressPickerView.h"

#define ADDRESS_NAME        @"请填写真实姓名"
#define ADDRESS_MOBILE      @"联系电话"
#define ADDRESS_CITY        @"选择省市区"
#define ADDRESS_DETEAIL     @"详细地址"
#define ADDRESS_CODE        @"邮编"

@interface AddressManangerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray         * titleArray;
    //姓名
    UITextField     * userNameTF;
    //详细地址
    UITextView      * addressTV;
    UILabel         * addressPlaceHolderLabel;
    //邮编
    UITextField     * codeTF;
    //用户所在地区
    NSString        * user_area;
    //选地区视图
    AddressPickerView * aPickerView;
}

@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)UserAddressModel * addressModel;

@end

@implementation AddressManangerViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.title_label.text = @"收货地址";
    
    _addressModel = [ZTools getAddressModel];
    if (_addressModel) {
        user_area = _addressModel.user_city;
    }else {
        _addressModel = [[UserAddressModel alloc] init];
    }
    
    titleArray = @[ADDRESS_NAME,ADDRESS_MOBILE,ADDRESS_CITY,ADDRESS_DETEAIL,ADDRESS_CODE];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.backgroundColor = RGBCOLOR(237, 237, 237);
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_myTableView addGestureRecognizer:tableViewGesture];
    
    [self createFooterView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [aPickerView removeFromSuperview];
    aPickerView = nil;
}
#pragma mark ---- FooterView
-(void)createFooterView{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
    footerView.backgroundColor = RGBCOLOR(237, 237, 237);
    _myTableView.tableFooterView = footerView;
    
    UIButton * saveButton = [ZTools createButtonWithFrame:CGRectMake(10, 50, DEVICE_WIDTH-20, 35) title:@"保存" image:nil];
    [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveButton];
}
#pragma mark -------  创建选地区视图
-(void)showAddressView{
    if (!aPickerView) {
        __WeakSelf__ wself = self;
        aPickerView = [AddressPickerView sharedInstance];
        [aPickerView selectedBlock:^(NSString *area) {
            user_area = area;
            NSInteger index = [titleArray indexOfObject:ADDRESS_CITY];
            [wself.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    [self.view endEditing:YES];
    [aPickerView show];
}

#pragma mark --------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * titleString = titleArray[indexPath.row];

    if ([titleString isEqualToString:ADDRESS_NAME] || [titleString isEqualToString:ADDRESS_MOBILE] || [titleString isEqualToString:ADDRESS_CITY] || [titleString isEqualToString:ADDRESS_CODE])
    {
        return 40;
    }else if ([titleString isEqualToString:ADDRESS_DETEAIL])//详细地址
    {
        return 60;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * titleString = titleArray[indexPath.row];
    if ([titleString isEqualToString:ADDRESS_NAME])//收货人姓名
    {
        
    }else if ([titleString isEqualToString:ADDRESS_MOBILE])//联系电话
    {
        
        
    }else if ([titleString isEqualToString:ADDRESS_CITY])//所在省市
    {
        [self showAddressView];
    }else if ([titleString isEqualToString:ADDRESS_DETEAIL])//详细地址
    {
        
    }else if ([titleString isEqualToString:ADDRESS_CODE])//邮编
    {

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.textLabel.font = [ZTools returnaFontWith:15];
    
    NSString * titleString = titleArray[indexPath.row];
    if ([titleString isEqualToString:ADDRESS_NAME])//收货人姓名
    {
        if (!userNameTF) {
            userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-20, 40)];
            userNameTF.delegate = self;
            userNameTF.font = [ZTools returnaFontWith:15];
            userNameTF.placeholder = titleString;
        }
        userNameTF.text = _addressModel.put_man;
        [cell.contentView addSubview:userNameTF];
    }else if ([titleString isEqualToString:ADDRESS_MOBILE])//联系电话
    {
        cell.textLabel.text = [NSString stringWithFormat:@"联系电话：%@",[ZTools getPhoneNum]];
        cell.textLabel.textColor = DEFAULT_GRAY_TEXT_COLOR;
        
    }else if ([titleString isEqualToString:ADDRESS_CITY])//所在省市
    {
        cell.textLabel.text = titleString;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = user_area;
        cell.detailTextLabel.font = [ZTools returnaFontWith:15];
    }else if ([titleString isEqualToString:ADDRESS_DETEAIL])//详细地址
    {
        if (!addressTV) {
            addressTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-20, 60)];
            addressTV.delegate = self;
            addressTV.font = [ZTools returnaFontWith:15];
        }
        addressTV.text = _addressModel.user_area;
        
        if (!addressPlaceHolderLabel) {
            addressPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, addressTV.width, 17)];
            addressPlaceHolderLabel.font = [ZTools returnaFontWith:15];
            addressPlaceHolderLabel.text = @"详细地址";
            addressPlaceHolderLabel.textColor = DEFAULT_GRAY_TEXT_COLOR;
        }
        
        addressPlaceHolderLabel.text = _addressModel.user_area.length?@"":@"详细地址";
        
        [cell.contentView addSubview:addressTV];
        [addressTV addSubview:addressPlaceHolderLabel];
        
    }else if ([titleString isEqualToString:ADDRESS_CODE])//邮编
    {
        if (!codeTF) {
            codeTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-20, 40)];
            codeTF.delegate = self;
            codeTF.font = [ZTools returnaFontWith:15];
            codeTF.placeholder = titleString;
            codeTF.keyboardType = UIKeyboardTypePhonePad;
        }
        
        codeTF.text = _addressModel.user_email.length?_addressModel.user_email:@"";
        
        [cell.contentView addSubview:codeTF];
    }
    
    return cell;
}

#pragma mark ----  UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (aPickerView) {
        [aPickerView hidden];
    }
    addressPlaceHolderLabel.text = @"";
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }

    addressPlaceHolderLabel.text = textView.text.length==0?@"详细地址":@"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        addressPlaceHolderLabel.text = @"详细地址";
    }
}
#pragma mark ------- UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (aPickerView) {
        [aPickerView hidden];
    }
    return YES;
}


#pragma mark ------  网络请求
-(void)saveButtonClicked:(UIButton *)button{
    [self.view endEditing:YES];
    
    if (userNameTF.text.length == 0 || codeTF.text.length == 0 || addressTV.text.length == 0 || user_area.length==0) {
        [ZTools showMBProgressWithText:@"请填写完整的信息" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (userNameTF.text.length > 15) {
        [ZTools showMBProgressWithText:@"收货人姓名至多15个字符" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    _addressModel.put_man = userNameTF.text;
    _addressModel.user_email = codeTF.text;
    _addressModel.user_area = addressTV.text;
    _addressModel.user_city = user_area;
    
    NSDictionary * dic = @{@"user_id":[ZTools getUid],
                           @"user_name":userNameTF.text,            //收货人姓名
                           @"user_mobile":[ZTools getPhoneNum],     // 收货人电话
                           @"user_city":user_area,                  //收货人所在省市
                           @"user_area":addressTV.text,             //收货人地址详细信息
                           @"user_email":codeTF.text};              //收货人邮编
    
    NSDictionary * addressInfo = @{@"put_man":userNameTF.text,
                                   @"user_city":user_area,
                                   @"user_area":addressTV.text,
                                   @"user_email":codeTF.text};
    
    __WeakSelf__ wself = self;
    [[ZAPI manager] sendPost:ADDRESS_MANAGER_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                [ZTools showMBProgressWithText:@"保存成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyUserInfomation" object:nil];
                
                //更改保存的地址信息
                NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"]];
                [userInfo setObject:addressInfo forKey:@"address"];
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"UserInfomationData"];
                
                [wself performSelector:@selector(saveSuccess) withObject:self afterDelay:1.5];
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }else{
            [ZTools showMBProgressWithText:@"请求失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
    } failure:^(NSError *error) {
        [ZTools showMBProgressWithText:@"请求失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark ----  保存成功
-(void)save:(addressManangerSaveSuccessBlock)block{
    saveBlock = block;
}
#pragma mark ----  自动消失
-(void)saveSuccess{
    if (saveBlock) {
        saveBlock(_addressModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}

-(void)dealloc{
    saveBlock = nil;
}


@end
