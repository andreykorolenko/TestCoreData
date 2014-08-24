//
//  PropertiesTableViewController.h
//  Lesson 41 home
//
//  Created by Андрей on 15.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "NewStudentTableViewController.h"

@class Student;

@interface PropertiesTableViewController : NewStudentTableViewController

@property (strong, nonatomic) Student *student;
@property (strong, nonatomic) NSMutableArray *coursesLearning;
@property (strong, nonatomic) NSMutableArray *coursesTeaching;

- (IBAction)actionSaveStudent:(UIButton *)sender;
- (IBAction)actionTextField:(UITextField *)sender;

@end
