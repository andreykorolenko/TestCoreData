//
//  NewCourse.h
//  Lesson 41 home
//
//  Created by Андрей on 16.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate, Courses;

@interface NewCourse : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) Courses *courseNew;
@property (strong, nonatomic) UITextField *courseNameField;

- (IBAction)addCourse:(UIButton *)sender;
- (void) showAlertWithTitle:(NSString *) title message:(NSString *) message delegate:(id) delegate;

@end
