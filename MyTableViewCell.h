//
//  MyTableViewCell.h
//  Lesson 41 home
//
//  Created by Андрей on 15.07.14.
//  Copyright (c) 2014 Andrey Korolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabelMain;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMain;

@end
