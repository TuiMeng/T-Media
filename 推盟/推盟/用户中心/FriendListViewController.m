//
//  FriendListViewController.m
//  推盟
//
//  Created by joinus on 15/12/29.
//  Copyright © 2015年 joinus. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListTableViewCell.h"

@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"好友列表";
    

    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark -------    UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    FriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
