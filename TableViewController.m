//
//  TableViewController.m
//  Lesson 41 home
//
//  Created by Андрей on 15.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "TableViewController.h"
#import "AppDelegate.h"
#import "Student.h"
#import "PropertiesTableViewController.h"
#import "NewStudentTableViewController.h"

@interface TableViewController () <UINavigationControllerDelegate>

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *application = [UIApplication sharedApplication];
    self.appDelegate = application.delegate;
    
    self.navigationController.delegate = self;
}

// запрос массива студентов из Core Data
- (NSArray *) requestArrayStudents {

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Student"
                                                   inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    
    NSError *requestError = nil;
    NSArray *resultArray = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

#pragma mark - UITableViewDataSource

// количество строк
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *temp = [self requestArrayStudents];
    return [temp count];
}

// создаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *temp = [self requestArrayStudents];
    Student *student = [temp objectAtIndex:indexPath.row];
    
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// удаляем студента
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *temp = [self requestArrayStudents];
        
        Student *student = [temp objectAtIndex:indexPath.row];
        [self.appDelegate.managedObjectContext deleteObject:student];
        
        NSError *error = nil;
        [self.appDelegate.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        [self.tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section];
        [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

#pragma mark - UITableViewDelegate

// надпись на кнопке удалить
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}

// при нажатии на студента
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *temp = [self requestArrayStudents];
    
    Student *student = [temp objectAtIndex:indexPath.row];
    
    PropertiesTableViewController *propertiesController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"PropertiesTableViewController"];
    
    propertiesController.student = student;
    
    [self.navigationController pushViewController:propertiesController animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[TableViewController class]]) {
        [self.tableView reloadData];
    }
}

#pragma mark - Actions

// добавить нового студента
- (IBAction)actionAddNewStudent:(UIBarButtonItem *)sender {
    
    NewStudentTableViewController *newStudentController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"NewStudentTableViewController"];
    
    [self.navigationController pushViewController:newStudentController animated:YES];
}

@end
