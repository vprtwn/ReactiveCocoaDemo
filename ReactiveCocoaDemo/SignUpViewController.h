//
//  ViewController.h
//  ReactiveCocoaDemo
//
//  Created by Ben Guo on 8/8/13.
//  Copyright (c) 2013 Ben Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end
