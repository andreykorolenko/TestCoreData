//
//  SettingsCourse.m
//  Lesson 41 home
//
//  Created by Андрей on 16.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "SettingsCourse.h"
#import "MyTableViewCell.h"
#import "cellCourses.h"
#import "Student.h"
#import "Courses.h"
#import "PropertiesTableViewController.h"
#import "addNewStudents.h"
#import "CoursesController.h"
#import "AddTeacherOnCourse.h"

@interface SettingsCourse ()

@end

@implementation SettingsCourse

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Подробнее";
    
    self.studentsOnCourse = [NSMutableArray arrayWithArray:[self.course.students allObjects]];
    [self.studentsOnCourse removeObject:self.course.teacher];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [self.studentsOnCourse sortUsingDescriptors:@[firstNameDescriptor]];
    
    Student *teacher = self.course.teacher;
    if (teacher) {
        self.teacherOnCourseArray = [NSMutableArray arrayWithObject:teacher];
    } else {
        self.teacherOnCourseArray = [NSMutableArray array];
    }
}

// запрос массива студентов из Core Data
- (NSArray *) requestStudents {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Student"
                                                   inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    
    NSError *requestError;
    NSArray *resultArray = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

#pragma mark - Actions

// кнопка сохранить курс
- (IBAction)actionSaveCourse:(UIButton *)sender {
    
    // если не введено название курса
    if ([self.courseNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не ввели название курса" delegate:nil];
    } else {
        if ([self.courseNameField isFirstResponder]) {
            [self.courseNameField resignFirstResponder];
        }
        // сохраняем курс в Core Data
        self.course.name = self.courseNameField.text;
        NSSet *setStudents = [NSSet setWithArray:self.studentsOnCourse];
        self.course.students = setStudents;
        
        NSError *error = nil;
        [self.appDelegate.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        [self showAlertWithTitle:@"Сохранено" message:@"Название курса сохранено" delegate:self];
    }
}

// кнопка добавить студентов
- (IBAction)actionAddStudents:(UIButton *)sender {
    
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"addNewStudents2"];
    NSArray *temp = navController.viewControllers;
    
    addNewStudents *addNewStudentsController = [temp firstObject];
    addNewStudentsController.course = self.course;
    addNewStudentsController.settingsCourse = self;
    
    [self presentViewController:navController animated:YES completion:nil];
}

// кнопка добавить преподавателя
- (IBAction)actionAddTeacher:(UIButton *)sender {
    
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"addNewStudents2"];
    
    AddTeacherOnCourse *teacherOnCourse = [[AddTeacherOnCourse alloc] init];
    teacherOnCourse.course = self.course;
    teacherOnCourse.settingsCourse = self;
    
    [navController setViewControllers:@[teacherOnCourse]];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

// количество секций
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// количество строк
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        NSInteger count = [self.teacherOnCourseArray count] + 1;
        return count;
    }
    
    else if (section == 2) {
        return [self.studentsOnCourse count] + 1;
    }
    
    return 2;
}

// создаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"Cell";
    UITableViewCell *cellStudent = [tableView dequeueReusableCellWithIdentifier:identifier];
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cellCourses *cellCourse = [tableView dequeueReusableCellWithIdentifier:@"cellCourses"];
    
    if (!cellStudent) {
        cellStudent = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cellStudent.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cellCourse.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.textLabelMain.text = @"Название курса";
        cell.textFieldMain.tag = 0;
        self.courseNameField = cell.textFieldMain;
        self.courseNameField.text = self.course.name;
        return cell;
    }
    
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellSave"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    // ячейка добавить преподавателя
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellAddTeacher"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    // преподаватель
    else if (indexPath.section == 1 && indexPath.row == 1) {
        
        if ([self.teacherOnCourseArray count] > 0) {
            Student *student = [self.teacherOnCourseArray objectAtIndex:indexPath.row - 1];
            cellStudent.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
            cellStudent.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cellStudent;
    }
    
    else if (indexPath.section == 2 && indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellAddStudent"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (indexPath.section == 2 && indexPath.row > 0) {
        
        if ([self.studentsOnCourse count] > 0) {
            Student *student = [self.studentsOnCourse objectAtIndex:indexPath.row - 1];
            cellStudent.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        }
        return cellStudent;
    }
    
    return cellCourse;
}

// удаляем строчку
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 1 && indexPath.row > 0) {
        
        Student *student = [self.teacherOnCourseArray objectAtIndex:indexPath.row - 1];
        
        // удаляем студента из преподавателя курса
        [self.teacherOnCourseArray removeObject:student];
        [self.course removeStudentsObject:student];
        self.course.teacher = nil;
        
        // убираем строчку из списка преподавателя на курса
        [self.tableView beginUpdates];
        NSIndexPath *path1 = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section];
        [self.tableView deleteRowsAtIndexPaths:@[path1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 2 && indexPath.row > 0) {
        
        Student *student = [self.studentsOnCourse objectAtIndex:indexPath.row - 1];
        
        // удаляем студента из списков студентов на курсе
        [self.studentsOnCourse removeObject:student];
        [self.course removeStudentsObject:student];
        
        // убираем строчку из списка студентов на курсе
        [self.tableView beginUpdates];
        NSIndexPath *path1 = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section];
        [self.tableView deleteRowsAtIndexPaths:@[path1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

// тайтлы секций
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Преподаватель";
    } else if (section == 2) {
        return @"Студенты";
    }
    return @"";
}

#pragma mark - UITableViewDelegate

// можно или нет удалять ячейки
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1 || indexPath.section == 2) && indexPath.row > 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// надпись на кнопке удалить
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}

// при выборе ячейки
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row > 0) {
        
        // переходим в настройки студента
        Student *student = [self.studentsOnCourse objectAtIndex:indexPath.row - 1];
        
        PropertiesTableViewController *propertiesController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"PropertiesTableViewController"];
        
        propertiesController.student = student;
        
        [self.navigationController pushViewController:propertiesController animated:YES];
    }
}

// высота ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 88.f;
    }
    return 44.f;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.courseNameField isFirstResponder]) {
        [self.courseNameField resignFirstResponder];
    }
    return YES;
}

@end
