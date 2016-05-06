//
//  MovieCityViewController.m
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieCityViewController.h"

@interface MovieCityViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UISearchDisplayController *searchDisplayController;
}

@property(nonatomic,strong)NSMutableArray * city_array;
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * searchArray;

@end

@implementation MovieCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"system_close_image"];
    
    self.title_label.text = [NSString stringWithFormat:@"当前城市-%@",_current_city];
    _city_array = [NSMutableArray array];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_myTableView];
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 43)];
    searchBar.placeholder = @"输入城市名称";
    _myTableView.tableHeaderView = searchBar;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    
    id cityDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"createCityDataTime"];

    if (cityDate && [cityDate isKindOfClass:[NSDate class]]) {
        NSDate * now = [NSDate date];
        double interval = [now timeIntervalSinceDate:cityDate];
        if (interval >= 7*24*60*60) {
            [self loadCityData];
        }else{
            id citys = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityData"];
            [self handleCityData:citys];
        }
    }else{
        [self loadCityData];
    }
}

-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ----- 网络请求
-(void)loadCityData{
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendMovieGet:GET_ALL_CITY_URL success:^(id data) {
        if (data && [data isKindOfClass:[NSArray class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cityData"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"createCityDataTime"];

            [wself handleCityData:data];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)handleCityData:(id)data{
    
    NSArray * array = (NSArray *)data;
    
    for (NSDictionary * dic in array) {
        id citys = dic[@"citys"];
        if ([citys isKindOfClass:[NSArray class]] && ![citys isKindOfClass:[NSNull class]]) {
            if ([(NSArray*)citys count]) {
                MovieCityModel * model = [[MovieCityModel alloc] initWithDictionary:dic];
                [self.city_array addObject:model];
            }
        }
    }
    
    [self.myTableView reloadData];
}

#pragma mark ------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.myTableView) {
        MovieCityModel * province_model = [_city_array objectAtIndex:section];
        
        return province_model.city_array.count;
    }else{
        if (!_searchArray) {
            _searchArray = [NSMutableArray array];
        }else{
            [_searchArray removeAllObjects];
        }
        
        for (MovieCityModel * model in _city_array) {
            for (SubCityModel * city in model.city_array) {
                if ([city.cityName rangeOfString:searchDisplayController.searchBar.text].length) {
                    [_searchArray addObject:city];
                }
            }
        }
        
        return _searchArray.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.myTableView) {
        return _city_array.count;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (tableView == self.myTableView) {
        MovieCityModel * province_model = [_city_array objectAtIndex:indexPath.section];
        SubCityModel * city_model = [province_model.city_array objectAtIndex:indexPath.row];
        cell.textLabel.text = city_model.cityName;
    }else{
        SubCityModel * city_model = [_searchArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city_model.cityName;
    }
    cell.textLabel.font = [ZTools returnaFontWith:16];
        
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.myTableView) {
        MovieCityModel * model = [_city_array objectAtIndex:section];
        
        UIView * section_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 30)];
        section_view.backgroundColor = [UIColor lightGrayColor];
        
        UILabel * province_label = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-30, section_view.height) text:model.province textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:15];
        [section_view addSubview:province_label];
        
        return section_view;
    }
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return tableView==self.myTableView?30:0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.myTableView) {
        MovieCityModel * province_model = [_city_array objectAtIndex:indexPath.section];
        SubCityModel * city_model = [province_model.city_array objectAtIndex:indexPath.row];
        city_block(city_model);
    }else{
        SubCityModel * city_model = [_searchArray objectAtIndex:indexPath.row];
        city_block(city_model);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)selectedCityWithCityBlock:(MovieCityViewControllerBlock)block{
    city_block = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    city_block = nil;
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
