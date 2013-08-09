//
//  PaymentViewController.h
//  ReactiveCocoaDemo
//
//  Created by Ben Guo on 8/9/13.
//  Copyright (c) 2013 Ben Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@end
