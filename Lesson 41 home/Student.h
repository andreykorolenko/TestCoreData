//
//  Student.h
//  Lesson 41 home
//
//  Created by Андрей on 17.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Courses, University;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSSet *courses;
@property (nonatomic, retain) University *university;
@property (nonatomic, retain) NSSet *teachers;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Courses *)value;
- (void)removeCoursesObject:(Courses *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

- (void)addTeachersObject:(Courses *)value;
- (void)removeTeachersObject:(Courses *)value;
- (void)addTeachers:(NSSet *)values;
- (void)removeTeachers:(NSSet *)values;

@end
