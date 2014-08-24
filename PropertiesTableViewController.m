//
//  PropertiesTableViewController.m
//  Lesson 41 home
//
//  Created by Андрей on 15.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "PropertiesTableViewController.h"
#import "AppDelegate.h"
#import "Student.h"
#import "MyTableViewCell.h"
#import "Courses.h"

@interface PropertiesTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSString *firstNameNew;
@property (strong, nonatomic) NSString *lastNameNew;
@property (strong, nonatomic) NSString *emailNew;

@end

@implementation PropertiesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Подробнее";
    
    // берем массив курсов, которые преподает студент и сортируем его по алфавиту
    NSArray *temp = [NSArray arrayWithArray:[self.student.teachers allObjects]];
    self.coursesTeaching = [NSMutableArray arrayWithArray:temp];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [self.coursesTeaching sortUsingDescriptors:@[nameDescriptor]];
    
    // берем массив курсов, которые изучает студент и сортируем его по алфавиту
    NSArray *temp2 = [NSArray arrayWithArray:[self.student.courses allObjects]];
    self.coursesLearning = [NSMutableArray arrayWithArray:temp2];
    [self.coursesLearning sortUsingDescriptors:@[nameDescriptor]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.coursesLearning count] == 0 && [self.coursesTeaching count] == 0) {
        return 1;
    }
    
    else if ([self.coursesLearning count] == 0 || [self.coursesTeaching count] == 0) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        if ([self.coursesTeaching count] > 0) {
            return [self.coursesTeaching count];
        } else {
            return [self.coursesLearning count];
        }
    } else if (section == 2) {
        return [self.coursesLearning count];
    }
    return 4;
}

// создаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Cell";
    
    UITableViewCell *cellBase = [tableView dequeueReusableCellWithIdentifier:identifier];
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cellBase) {
        cellBase = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cellBase.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.textLabelMain.text = @"Имя";
        cell.textFieldMain.text = self.student.firstName;
        cell.textFieldMain.tag = 0;
        self.firstNameNew = cell.textFieldMain.text;
        self.firstNameField = cell.textFieldMain;
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.textLabelMain.text = @"Фамилия";
        cell.textFieldMain.text = self.student.lastName;
        cell.textFieldMain.tag = 1;
        self.lastNameNew = cell.textFieldMain.text;
        self.lastNameField = cell.textFieldMain;
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        cell.textLabelMain.text = @"Mail";
        cell.textFieldMain.text = self.student.mail;
        cell.textFieldMain.tag = 2;
        self.emailNew = cell.textFieldMain.text;
        cell.textFieldMain.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textFieldMain.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailField = cell.textFieldMain;
        
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellSave"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.section == 1) {
        
        if ([self.coursesTeaching count] > 0) {
            Courses *course = [self.coursesTeaching objectAtIndex:indexPath.row];
            cellBase.textLabel.text = course.name;
            return cellBase;
        } else if ([self.coursesLearning count] > 0) {
            Courses *course = [self.coursesLearning objectAtIndex:indexPath.row];
            cellBase.textLabel.text = course.name;
            return cellBase;
        }
        
    } else if (indexPath.section == 2) {
        
        Courses *course = [self.coursesLearning objectAtIndex:indexPath.row];
        cellBase.textLabel.text = course.name;
        return cellBase;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        if ([self.coursesTeaching count] > 0) {
            return @"Курсы, которые преподает";
        } else {
            return @"Курсы, которые изучает";
        }
    }
    
    else if (section == 2) {
        return @"Курсы, которые изучает";
    }
    return @"";
}

#pragma mark - Actions

// кнопка сохранить студента
- (IBAction)actionSaveStudent:(UIButton *)sender {
    
    if ([self.firstNameField.text isEqualToString:@""] && [self.lastNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не заполнили обязательные поля Имя и Фамилия" delegate:nil];
    } else if ([self.firstNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не заполнили Имя" delegate:nil];
    }  else if ([self.lastNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не заполнили Фамилию" delegate:nil];
        
    } else {
        
        self.student.firstName = self.firstNameNew;
        self.student.lastName = self.lastNameNew;
        self.student.mail = self.emailField.text;
        
        NSError *error = nil;
        [self.appDelegate.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        if ([self.firstNameField isFirstResponder]) {
            [self.firstNameField resignFirstResponder];
        } else if ([self.lastNameField isFirstResponder]) {
            [self.lastNameField resignFirstResponder];
        } else if ([self.emailField isFirstResponder]) {
            [self.emailField resignFirstResponder];
        }
        
        [self showAlertWithTitle:@"Сохранено" message:@"Изменения данных о студенте сохранены" delegate:self];
    }
}

// изменение textField
- (IBAction)actionTextField:(UITextField *)sender {
    
    if (sender.tag == 0) {
        self.firstNameNew = sender.text;
    } else if (sender.tag == 1) {
        self.lastNameNew = sender.text;
    } else if (sender.tag == 2) {
        self.emailNew = sender.text;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
