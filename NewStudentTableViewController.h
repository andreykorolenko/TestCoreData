//
//  NewStudentTableViewController.h
//  Lesson 41 home
//
//  Created by Андрей on 15.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface NewStudentTableViewController : UITableViewController

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *emailField;

- (IBAction)actionAddNewStudent:(UIButton *)sender;
- (void) showAlertWithTitle:(NSString *) title message:(NSString *) message delegate:(id) delegate;

@end
