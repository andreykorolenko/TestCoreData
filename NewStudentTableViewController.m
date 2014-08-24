//
//  NewStudentTableViewController.m
//  Lesson 41 home
//
//  Created by Андрей on 15.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "NewStudentTableViewController.h"
#import "AppDelegate.h"
#import "MyTableViewCell.h"
#import "Student.h"

@interface NewStudentTableViewController () <UITextFieldDelegate>

@end

@implementation NewStudentTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *application = [UIApplication sharedApplication];
    self.appDelegate = application.delegate;
    
    self.navigationItem.title = @"Новый студент";
}

// показать alertView
- (void) showAlertWithTitle:(NSString *) title message:(NSString *) message delegate:(id) delegate {
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - UITableViewDataSource

// количество строк
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

// создаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        
        cell.textLabelMain.text = @"Имя";
        cell.textFieldMain.tag = 0;
        self.firstNameField = cell.textFieldMain;
        
    } else if (indexPath.row == 1) {
        
        cell.textLabelMain.text = @"Фамилия";
        cell.textFieldMain.tag = 1;
        self.lastNameField = cell.textFieldMain;
        
    } else if (indexPath.row == 2) {
        
        cell.textLabelMain.text = @"Mail";
        cell.textFieldMain.tag = 2;
        cell.textFieldMain.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textFieldMain.returnKeyType = UIReturnKeyDone;
        cell.textFieldMain.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailField = cell.textFieldMain;
        
    } else if (indexPath.row == 3) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellSave"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


#pragma mark - Actions

// кнопка Добавить
- (IBAction)actionAddNewStudent:(UIButton *)sender {
    
    if ([self.firstNameField.text isEqualToString:@""] && [self.lastNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не заполнили обязательные поля Имя и Фамилия" delegate:nil];
    } else if ([self.firstNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не заполнили Имя" delegate:nil];
    }  else if ([self.lastNameField.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"Ошибка" message:@"Вы не заполнили Фамилию" delegate:nil];
    } else {
        // убираем клавиатуру при нажатии на кнопку добавить
        if ([self.firstNameField isFirstResponder]) {
            [self.firstNameField resignFirstResponder];
        } else if ([self.lastNameField isFirstResponder]) {
            [self.lastNameField resignFirstResponder];
        } else if ([self.emailField isFirstResponder]) {
            [self.emailField resignFirstResponder];
        }
        
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student"
                                                         inManagedObjectContext:self.appDelegate.managedObjectContext];
        student.firstName = self.firstNameField.text;
        student.lastName = self.lastNameField.text;
        student.mail = self.emailField.text;
        
        NSError *error = nil;
        
        [self.appDelegate.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        [self showAlertWithTitle:@"Уведомление" message:@"Вы успешного добавили нового студента" delegate:self];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.firstNameField isFirstResponder]) {
        [self.lastNameField becomeFirstResponder];
    } else if ([self.lastNameField isFirstResponder]) {
        [self.emailField becomeFirstResponder];
    } else if ([self.emailField isFirstResponder]) {
        [self.emailField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
