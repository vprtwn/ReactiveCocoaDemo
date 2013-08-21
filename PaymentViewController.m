//
//  PaymentViewController.m
//  ReactiveCocoaDemo
//
//  Created by Ben Guo on 8/9/13.
//  Copyright (c) 2013 Ben Guo. All rights reserved.
//

#import "PaymentViewController.h"
#import "ReactiveCocoa.h"
#import "EXTScope.h"

@interface PaymentViewController ()

// array of NSNumbers representing tip amounts
// ex.  0    => No Tip
//      0.15 => 15%
//      2    => $2
@property NSArray *tipOptions;

@property NSNumber *amount;
@property NSNumber *tip;
@property NSNumber *total;


@end

@implementation PaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);

    // Assign self.amount to a signal mapped from amount textfield
    // - use RAC() to assign a keypath to a signal.
    RAC(self.amount) =
    [self.amountTextField.rac_textSignal
     map:^NSNumber *(NSString *amountText) {
         return @(amountText.doubleValue);
     }];
    
    // Assign self.tipOptions to a signal mapped from self.amount that's
    //  [0, 1, 2, 3] if amount < 10 and [0, .15, .2, .25] otherwise
    // - use RACAble(self.amount) to create a signal that observes a keypath for changes
    // Update the tip segmented control whenever the signal sends a new value
    // - use distinctUntilChanged: when you want the signal to only send distinct values
    // - use doNext: to inject side effects into a signal
    // - use weakify and strongify to avoid retain cycles
    RAC(self.tipOptions) =
    [[[RACAble(self.amount)
       map:^NSArray *(NSNumber * amount) {
           if (amount.doubleValue < 10) {
               return @[@0, @1, @2, @3];
           } else {
               return @[@0, @0.15, @0.2, @0.25];
           }
       }] distinctUntilChanged]
     doNext:^(NSArray *array) {
         @strongify(self);
         [self updateTipSegmentedControlWithOptions:array];
     }];
    

    // Assign self.tip to a signal combining self.amount and self.tipSegmentedControl
    // - use combineLatest:reduce: to combine signals
    // - use rac_signalForControlEvents to get a signal from a UIControl
    // Update self.tipTextField.text whenever self.tip changes 
    RAC(self.tip) =
    [[[RACSignal combineLatest:@[RACAble(self.amount),
                                [self.tipSegmentedControl rac_signalForControlEvents:UIControlEventValueChanged]]
                       reduce:^(NSNumber *amount, UISegmentedControl *control) {
                           double tip = [self.tipOptions[control.selectedSegmentIndex] doubleValue];
                           if (tip < 1) {
                               return @(self.amount.doubleValue*tip);
                           } else {
                               return @(tip);
                           }
                       }
      ] distinctUntilChanged]
     doNext:^(NSNumber *tip) {
         @strongify(self);
         self.tipTextField.text = [NSString stringWithFormat:@"+ $%.2f", tip.doubleValue];
     }];
    
    // Assign self.total to a signal combining amount and tip
    // Update self.totalAmountLabel.text whenever self.total changes
    RAC(self.total) =
    [[[RACSignal combineLatest:@[RACAble(self.amount), RACAble(self.tip)]
                        reduce:^(NSNumber *amount, NSNumber *tip) {
                            return @(amount.doubleValue + tip.doubleValue);
                        }
       ] distinctUntilChanged]
     doNext:^(NSNumber *total) {
         @strongify(self);
         self.totalAmountLabel.text = [NSString stringWithFormat:@"$%.2f", total.doubleValue];
     }];
    
    // combineLatest: only sends a value once both streams are non empty
    // so we need to make sure RACAble(self.tip) is a non-empty stream
    self.tip = @(0);
    

    
}

// updates self.tipSegmentedControl with the proper titles based on tipOptions
- (void)updateTipSegmentedControlWithOptions:(NSArray *)tipOptions {
    NSString *tipText = @"";
    for (int i = 0; i<4; i++) {
        NSNumber *tip = tipOptions[i];
        // 0 => No tip
        if (tip.doubleValue == 0) {
            tipText = @"No tip";
        } else if (tip.doubleValue < 1) {
            tipText = [NSString stringWithFormat:@"%%%.0f", tip.doubleValue*100];
        } else {
            tipText = [NSString stringWithFormat:@"$%@", tip.stringValue];
        }
        [self.tipSegmentedControl setTitle:tipText
                         forSegmentAtIndex:i];
    }
}


@end
