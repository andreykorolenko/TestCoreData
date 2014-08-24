//
//  teachersController.m
//  Lesson 41 home
//
//  Created by Андрей on 18.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import "teachersController.h"
#import "Student.h"
#import "AppDelegate.h"
#import "PropertiesTableViewController.h"

@interface teachersController ()

@property (strong, nonatomic) NSMutableArray *teachers;

@end

@implementation teachersController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *application = [UIApplication sharedApplication];
    self.appDelegate = application.delegate;
}

// запрос массива преподавателей из Core Data
- (NSArray *) requestStudentsTeachers {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Student"
                                                   inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teachers.@count > %d", 0];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    [request setEntity:description];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[nameDescriptor]];
    
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
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self requestStudentsTeachers]];
    return [temp count];
}

// создаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self requestStudentsTeachers]];
    
    Student *student = [temp objectAtIndex:indexPath.row];
    
    NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    if ([student.teachers count] == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d курс", [student.teachers count]];
    } else if ([student.teachers count] == 2 || [student.teachers count] == 3 || [student.teachers count] == 4) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d курса", [student.teachers count]];
    } else if ([student.teachers count] >= 5) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d курсов", [student.teachers count]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// при нажатии на студента
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self requestStudentsTeachers]];
    
    Student *student = [temp objectAtIndex:indexPath.row];
    
    PropertiesTableViewController *propertiesController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"PropertiesTableViewController"];
    
    propertiesController.student = student;
    
    [self.navigationController pushViewController:propertiesController animated:YES];
}

@end
