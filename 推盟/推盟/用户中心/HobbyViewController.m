//
//  HobbyViewController.m
//  推盟
//
//  Created by joinus on 15/9/10.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "HobbyViewController.h"
#define INDENT 30
#define PADDING 15


@interface HobbyViewController (){
    
}

@property(nonatomic,strong)UIScrollView * myScrollView;

@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)NSMutableArray * temp_array;

@end

@implementation HobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title_label.text = @"兴趣爱好";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"确认"];
    
    _data_array = [NSMutableArray array];//WithArray:@[@"母婴",@"电影",@"游泳",@"绘画高手",@"K歌大人",@"看书",@"篮球",@"网上冲浪",@"足球",@"弹琴",@"观光世界",@"睡觉",@"极限挑战",@"跳舞",@"吃吃喝喝",@"登山",@"烹饪",@"购物血拼"]];
    _temp_array = [NSMutableArray arrayWithArray:_titles_array];
   
    
    [self startLoading];
    [self loadhobbyTitlesData];
}

-(void)setup{
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    [self.view addSubview:_myScrollView];
    
    UIImage * prompt_image = [UIImage imageNamed:@"personal_info_hobby_image"];
    UIImageView * prompt_imageView = [[UIImageView alloc] initWithImage:prompt_image];
    prompt_imageView.center = CGPointMake(DEVICE_WIDTH/2.0f,20+prompt_image.size.height/2.0f);
    [_myScrollView addSubview:prompt_imageView];
    
    
    float width = INDENT;
    float height = 50;
    
    for (int i = 0; i < _data_array.count; i++) {
        NSString * title = [_data_array objectAtIndex:i];
        CGSize title_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:title WithWidth:MAXFLOAT];
        
        if (width + title_size.width+20+PADDING > DEVICE_WIDTH) {
            width = INDENT;
            height += 45;
        }
        
        UIButton * button = [ZTools createButtonWithFrame:CGRectMake(width, height, title_size.width+20, 25) tag:100+i title:title image:nil];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
        button.titleLabel.font = [ZTools returnaFontWith:15];
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 5;
        [_myScrollView addSubview:button];
        
        if ([_temp_array containsObject:title]) {
            button.selected = YES;
            button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        }
        
        width += (title_size.width + 20 + PADDING);
    }
    
    _myScrollView.contentSize = CGSizeMake(0, height+50);
}

#pragma mark ----  网络请求
-(void)loadhobbyTitlesData{
    __weak typeof(self)wself = self;
    NSLog(@"-------   %@",HOBBY_TITLES_URL);
    [[ZAPI manager] sendGet:HOBBY_TITLES_URL success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]])
        {
            NSMutableArray * array = [NSMutableArray array];
            if ([[data objectForKey:@"status"] intValue] == 1)
            {
                NSArray * titles_array = [data objectForKey:@"titles"];
                for (NSDictionary * dic in titles_array) {
                    [array addObject:dic[@"content"]];
                }
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:HOBBY_TITLES];
               
            }else{
                array = [[NSUserDefaults standardUserDefaults] objectForKey:HOBBY_TITLES];
            }
            [wself.data_array addObjectsFromArray:array];
            [wself setup];
        }
    } failure:^(NSError *error) {
        [wself endLoading];
        [wself.data_array addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:HOBBY_TITLES]];
        [wself setup];
    }];
}

-(void)submitData{
    
    if (_temp_array.count == 0) {
        [ZTools showMBProgressWithText:@"请选择您感兴趣的标签" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    NSString * hobby_string = [_temp_array componentsJoinedByString:@"|"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"hobby_id":hobby_string,@"user_id":[ZTools getUid]}];
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"提交中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    NSLog(@"dic ------   %@",dic);
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:MODIFY_USER_INFOMATION_URL myParams:dic success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:@"status"] intValue] == 1) {
                [ZTools showMBProgressWithText:@"修改成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyUserInfomation" object:nil];
                [wself disappearWithPOP:YES afterDelay:1.5];
            }else{
                [ZTools showMBProgressWithText:[data objectForKey:@"errorinfo"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }else{
            [ZTools showMBProgressWithText:@"提交失败，请重试" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"提交失败，请重试" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];

}

-(void)rightButtonTap:(UIButton *)sender{
    
    [self submitData];
}

-(void)buttonTap:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        [_temp_array addObject:sender.titleLabel.text];
    }else{
        sender.backgroundColor = [UIColor whiteColor];
        [_temp_array removeObject:sender.titleLabel.text];
    }
}

-(void)selectedBlock:(HobbySelectedBlock)block{
    hobby_block = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    _titles_array = nil;
    _data_array = nil;
    _myScrollView = nil;
    _temp_array = nil;
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
