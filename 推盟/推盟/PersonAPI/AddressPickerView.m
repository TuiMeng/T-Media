//
//  AddressPickerView.m
//  推盟
//
//  Created by joinus on 16/6/13.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "AddressPickerView.h"

@interface AddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray * area_array;
    int _flagRow;
    int _flagRow1;
    //用户地区
    NSString * user_area_string;
    
    NSMutableArray * cityDataArray;
}

@property(nonatomic,strong)UIPickerView * pickerView;

@end

@implementation AddressPickerView

+(instancetype)sharedInstance{
    return [[[self class] alloc] init];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createMainView];
    }
    return self;
}

-(void)createMainView{
    
    self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 260);
    self.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"   取消" style:UIBarButtonItemStylePlain target:self action:@selector(hidden)];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确认   " style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClicked)];
    toolBar.items = @[cancelItem,spaceItem,doneItem];
    [self addSubview:toolBar];
    
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.bottom, DEVICE_WIDTH, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
    [self getAddressData];
}

-(void)getAddressData{
    
    if (cityDataArray && cityDataArray.count) {
        [self show];
        return;
    }
    
    __weak typeof(self)bself = self;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"citydata.plist" ofType:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        cityDataArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            [bself.pickerView reloadAllComponents];
            [bself show];
        });
    });
}

-(void)selectedBlock:(addressPickViewSelectedBlock)block{
    myBlock = block;
}
#pragma mark ---- 显示/隐藏
-(void)show{
    [UIView animateWithDuration:0.4 animations:^{
        self.bottom = DEVICE_HEIGHT;
    }];
}
-(void)hidden{
    [UIView animateWithDuration:0.4 animations:^{
        self.top = DEVICE_HEIGHT;
    }];
}
#pragma mark -----  确认按钮
-(void)doneItemClicked{
    if (user_area_string.length == 0) {
        user_area_string = @"北京北京东城区";
        if (myBlock) {
            myBlock(user_area_string);
        }
    }
    [self hidden];
}

#pragma mark --------   UIPickerViewDelegate ------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return cityDataArray.count?3:0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return cityDataArray.count;
        
    } else if (component == 1) {
        int proIndex = (int)[pickerView selectedRowInComponent:0];
        NSArray * cities = cityDataArray[proIndex][@"citylist"];
        return cities.count;
    }else if (component == 2) {
        int proIndex = (int)[pickerView selectedRowInComponent:0];
        int cityIndex = (int)[pickerView selectedRowInComponent:1];
        NSArray * areas = cityDataArray[proIndex][@"citylist"][cityIndex][@"arealist"];
        return areas.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
    {
        return cityDataArray[row][@"provinceName"];
        
    } else if (component == 1)
    {
        int proIndex = (int)[pickerView selectedRowInComponent:0];
        NSString * _str2 = cityDataArray[proIndex][@"citylist"][row][@"cityName"];
        return _str2;
    }else if (component == 2) {
        int proIndex = (int)[pickerView selectedRowInComponent:0];
        int cityIndex = (int)[pickerView selectedRowInComponent:1];
        NSString * area = cityDataArray[proIndex][@"citylist"][cityIndex][@"arealist"][row][@"areaName"];
        return area;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component+1 < 3) {
        [pickerView selectRow:0 inComponent:component+1 animated:YES];
    }
    
    //找到选择的省市县
    int proIndex = (int)[pickerView selectedRowInComponent:0];
    int cityIndex = (int)[pickerView selectedRowInComponent:1];
    int areaIndex = (int)[pickerView selectedRowInComponent:2];
    
    NSString * proString = cityDataArray[proIndex][@"provinceName"];
    NSString * cityString = cityDataArray[proIndex][@"citylist"][cityIndex][@"cityName"];
    NSString * areaString = cityDataArray[proIndex][@"citylist"][cityIndex][@"arealist"][areaIndex][@"areaName"];
    
    user_area_string = [NSString stringWithFormat:@"%@%@%@",proString,cityString,areaString];
    
    if (myBlock) {
        myBlock(user_area_string);
    }
    
    [pickerView reloadAllComponents];
}



-(void)dealloc{
    [area_array removeAllObjects];
    area_array = nil;
}


@end














