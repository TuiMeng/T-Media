//
//  ViewController.m
//  推盟
//
//  Created by joinus on 15/7/28.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ViewController.h"
#import "RootViewController.h"
#import "MenuViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    MenuViewController * menu = [[MenuViewController alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RootViewController * rootVC = (RootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    
    [self setMaximumLeftDrawerWidth:(DEVICE_WIDTH - [ZTools autoWidthWith:65])];
    [self setCenterViewController:rootVC];
    [self setLeftDrawerViewController:menu];
    [self setShowsShadow:YES];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
