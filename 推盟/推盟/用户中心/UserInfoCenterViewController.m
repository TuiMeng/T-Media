//
//  UserInfoCenterViewController.m
//  推盟
//
//  Created by joinus on 16/1/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "UserInfoCenterViewController.h"

@interface UserInfoCenterViewController ()<SNRefreshDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet SNRefreshTableView *myTableView;



@end

@implementation UserInfoCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
}

-(void)createSectionView{
    
}

#pragma mark ----  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

#pragma mark -----  SNRefreshTableViewDelegate
- (void)loadNewData{
    
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UIView *)viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    return 0;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
