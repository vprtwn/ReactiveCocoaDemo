//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by Ben Guo on 8/8/13.
//  Copyright (c) 2013 Ben Guo. All rights reserved.
//

#import "SignUpViewController.h"
#import "ReactiveCocoa.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RAC(self.signUpButton, enabled) =
    [RACSignal combineLatest:@[self.usernameTextField.rac_textSignal,
                               self.passwordTextField.rac_textSignal,
                               self.confirmPasswordTextField.rac_textSignal]
                      reduce:^(NSString *username,
                               NSString *password,
                               NSString *passwordConfirm) {
                          return @(username.length > 5
                          && password.length > 8
                          && passwordConfirm.length > 8
                          && [password isEqualToString:passwordConfirm]);
                      }];
    
    RAC(self.errorLabel, text) =
    [RACSignal combineLatest:@[self.usernameTextField.rac_textSignal,
                               self.passwordTextField.rac_textSignal,
                               self.confirmPasswordTextField.rac_textSignal]
                      reduce:^(NSString *username,
                               NSString *password,
                               NSString *passwordConfirm) {
                          if (username.length <= 5) {
                              return @"username is too short";
                          } else if (password.length <= 8) {
                              return @"password is too short";
                          } else if (![passwordConfirm isEqualToString:password]) {
                              return @"password confirm doesn't match";
                          } else {
                              return @"looks good!";
                          }
                      }];
}

@end
