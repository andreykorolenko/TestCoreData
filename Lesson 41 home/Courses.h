//
//  Courses.h
//  Lesson 41 home
//
//  Created by Андрей on 17.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, University;

@interface Courses : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) Student *teacher;
@property (nonatomic, retain) University *university;
@end

@interface Courses (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
