//
//  AddTeacherOnCourse.m
//  Lesson 41 home
//
//  Created by Андрей on 17.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "AddTeacherOnCourse.h"

@interface AddTeacherOnCourse ()

@property (strong, nonatomic) NSMutableArray *teacherOnCourseArray;
@property (strong, nonatomic) Student *teacher;

@end

@implementation AddTeacherOnCourse

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Преподаватели";
    
    self.teacherOnCourseArray = [NSMutableArray array];
    self.teacher = self.course.teacher;
    
    if (self.teacher) {
        [self.teacherOnCourseArray addObject:self.teacher];
    }
    
    // создаем массив всех студентов
    NSArray *temp = [self requestArrayStudents];
    self.studentsAll = [NSMutableArray arrayWithArray:temp];
    
    // создаем кнопку назад
    UIImage *backImage = [UIImage imageNamed:@"Previous"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
}

#pragma mark - Actions

// кнопка назад
- (void) backButton:(UIBarButtonItem *) sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if ([student isEqual:self.course.teacher]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

// при нажатии на ячейку
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *cellsArray = tableView.visibleCells;
    
    Student *student = [self.studentsAll objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        // удаляем преподователя из курса
        self.course.teacher = nil;
        NSMutableArray *temp = [NSMutableArray array];
        self.settingsCourse.teacherOnCourseArray = temp;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // убрать чекмарки у остальных
        for (UITableViewCell *cellInArray in cellsArray) {
            if ((cellInArray != cell) && cellInArray.accessoryType == UITableViewCellAccessoryCheckmark) {
                cellInArray.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        // добавляем преподавателя на курс
        self.course.teacher = student;
        
        NSMutableArray *temp = [NSMutableArray arrayWithObject:student];
        self.settingsCourse.teacherOnCourseArray = temp;
        [self.settingsCourse.studentsOnCourse removeObject:student];
    }
    
    [self.settingsCourse.tableView reloadData];
}

@end
