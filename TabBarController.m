//
//  TabBarController.m
//  Lesson 41 home
//
//  Created by Андрей on 18.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "TabBarController.h"
#import "teachersController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    UINavigationController *navController = (UINavigationController *)viewController;
    
    teachersController *teachController = [navController.viewControllers firstObject];
    [teachController.tableView reloadData];
}

@end
