//
//  TableViewController.h
//  Lesson 41 home
//
//  Created by Андрей on 15.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface TableViewController : UITableViewController

@property (weak, nonatomic) AppDelegate *appDelegate;

- (IBAction)actionAddNewStudent:(UIBarButtonItem *)sender;
- (NSArray *) requestArrayStudents;

@end
