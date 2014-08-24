//
//  addNewStudents.h
//  Lesson 41 home
//
//  Created by Андрей on 17.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"
#import "Courses.h"
#import "SettingsCourse.h"

@interface addNewStudents : UITableViewController

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) Courses *course;
@property (strong, nonatomic) SettingsCourse *settingsCourse;
@property (strong, nonatomic) NSMutableArray *studentsOnCourse;
@property (strong, nonatomic) NSMutableArray *studentsAll;

- (IBAction)actionBack:(UIBarButtonItem *)sender;
- (NSArray *) requestArrayStudents;

@end
