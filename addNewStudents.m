//
//  addNewStudents.m
//  Lesson 41 home
//
//  Created by Андрей on 17.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "addNewStudents.h"

#import "CoursesController.h"

@interface addNewStudents () <UINavigationControllerDelegate>

@end

@implementation addNewStudents

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *application = [UIApplication sharedApplication];
    self.appDelegate = application.delegate;
    self.navigationController.delegate = self;
    
    self.navigationItem.title = @"Студенты";
    
    // создаем массив студентов на этом курсе
    NSArray *temp = [NSArray arrayWithArray:[self.course.students allObjects]];
    self.studentsOnCourse = [NSMutableArray arrayWithArray:temp];
    
    // создаем массив всех студентов
    NSArray *temp2 = [self requestArrayStudents];
    self.studentsAll = [NSMutableArray arrayWithArray:temp2];
    [self.studentsAll removeObject:self.course.teacher];
}

// запрос массива студентов из Core Data
- (NSArray *) requestArrayStudents {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Student"
                                                   inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [request setEntity:description];
    [request setSortDescriptors:@[firstNameDescriptor]];
    
    NSError *requestError = nil;
    NSArray *resultArray = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

#pragma mark - Actions 

- (IBAction)actionBack:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = [self.studentsAll count];
    return count;
}

// создаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Student *student = [self.studentsAll objectAtIndex:indexPath.row];
    
    NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    for (Student *student1 in self.studentsOnCourse) {
        if ([student1 isEqual:student]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

// при нажатии на ячейку
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Student *student = [self.studentsAll objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        // удаляем студента из курса
        [self.course removeStudentsObject:student];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // добавляем студента на курс
        [self.course addStudentsObject:student];
    }
    
    NSArray *temp = [NSArray arrayWithArray:[self.course.students allObjects]];
    NSMutableArray *temp2 = [NSMutableArray arrayWithArray:temp];
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [temp2 sortUsingDescriptors:@[firstNameDescriptor]];
    
    self.settingsCourse.studentsOnCourse = temp2;
    
    [self.settingsCourse.tableView reloadData];
}

@end
