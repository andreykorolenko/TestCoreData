//
//  NewCourse.m
//  Lesson 41 home
//
//  Created by Андрей on 16.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "NewCourse.h"
#import "AppDelegate.h"
#import "Courses.h"
#import "MyTableViewCell.h"
#import "cellCourses.h"
#import "Student.h"

@interface NewCourse ()

@end

@implementation NewCourse

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *application = [UIApplication sharedApplication];
    self.appDelegate = application.delegate;
    
    self.navigationItem.title = @"Новый курс";
}

// показать alertView
- (void) showAlertWithTitle:(NSString *) title message:(NSString *) message delegate:(id) delegate {
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - UITableViewDataSource

// количество строк
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// создаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        cell.textLabelMain.text = @"Название курса";
        self.courseNameField = cell.textFieldMain;
    }
    
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellSave"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

// высота ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 88.f;
    }
    
    return 44.f;
}

#pragma mark - Actions

// добавляем новый курс в Core Data
- (IBAction)addCourse:(UIButton *)sender {

    // если строка названия курса пуста
    if ([self.courseNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не ввели название курса" delegate:nil];
    } else {
        // убираем клавиатуру при нажатии на кнопку добавить
        if ([self.courseNameField isFirstResponder]) {
            [self.courseNameField resignFirstResponder];
        }
        // добавляем новый курс в Core Data
        self.courseNew = [NSEntityDescription insertNewObjectForEntityForName:@"Courses"
                                                       inManagedObjectContext:self.appDelegate.managedObjectContext];
        self.courseNew.name = self.courseNameField.text;
        
        NSError *error = nil;
        [self.appDelegate.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        [self showAlertWithTitle:@"Уведомление" message:@"Вы успешно добавили новый курс" delegate:self];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.courseNameField isFirstResponder]) {
        [self.courseNameField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
