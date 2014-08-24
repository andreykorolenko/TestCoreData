//
//  CoursesController.m
//  Lesson 41 home
//
//  Created by Андрей on 16.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "CoursesController.h"
#import "AppDelegate.h"
#import "NewCourse.h"
#import "Courses.h"
#import "NewCourse.h"
#import "SettingsCourse.h"

@interface CoursesController () <UINavigationControllerDelegate>

@property (weak, nonatomic) AppDelegate *appDelegate;

@end

@implementation CoursesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *application = [UIApplication sharedApplication];
    self.appDelegate = application.delegate;
    
    self.navigationController.delegate = self;
}

// запрос массива курсов из Core Data
- (NSArray *) requestArrayCourses {

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Courses"
                                                   inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:description];
    
    NSError *requestError;
    NSArray *resultArray = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *temp = [self requestArrayCourses];
    return [temp count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *temp = [self requestArrayCourses];
    
    Courses *course = [temp objectAtIndex:indexPath.row];
    
    NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = course.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// удаляем курс
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *temp = [self requestArrayCourses];
        
        Courses *course = [temp objectAtIndex:indexPath.row];
        [self.appDelegate.managedObjectContext deleteObject:course];
        
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

// при нажатии на курс
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *temp = [self requestArrayCourses];
    
    Courses *course = [temp objectAtIndex:indexPath.row];
    
    SettingsCourse *settingsCourse = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsCourse"];
    settingsCourse.course = course;
    
    [self.navigationController pushViewController:settingsCourse animated:YES];
}

// надпись на кнопке удалить
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}

#pragma mark - Actions

// кнопка создать новый курс
- (IBAction)actionAddNewCourse:(UIBarButtonItem *)sender {
    
    NewCourse *newCourse = [self.storyboard instantiateViewControllerWithIdentifier:@"NewCourse"];
    
    [self.navigationController pushViewController:newCourse animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[CoursesController class]]) {
        [self.tableView reloadData];
    }
}

@end
