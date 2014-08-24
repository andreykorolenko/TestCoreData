//
//  SettingsCourse.h
//  Lesson 41 home
//
//  Created by Андрей on 16.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "NewCourse.h"

@class Courses;

@interface SettingsCourse : NewCourse

@property (strong, nonatomic) Courses *course;
@property (strong, nonatomic) NSMutableArray *studentsOnCourse;
@property (strong, nonatomic) NSMutableArray *teacherOnCourseArray;

- (IBAction)actionSaveCourse:(UIButton *)sender;
- (IBAction)actionAddStudents:(UIButton *)sender;
- (IBAction)actionAddTeacher:(UIButton *)sender;

@end
