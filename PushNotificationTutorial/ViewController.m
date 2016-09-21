/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ViewController.h"
#import <Parse/Parse.h>

@implementation ViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Parse Push Notifications", @"Parse Push Notifications")];
    
    [self loadInstallData];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - UIViewController

/* Touch handler for the button */
- (IBAction)broadcastPushNotification:(id)sender  {
    [PFPush sendPushMessageToChannelInBackground:@"global" withMessage:@"Hello World!" block:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Send Push Failed"
                                                                                     message:@"Check the console for more information."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (IBAction)updateInstallation:(id)sender {
    NSString *gender = @"male";
    if (self.genderControl.selectedSegmentIndex == 1) {
        gender = @"female";
    }

    NSNumber *age = @((int)self.ageControl.value);
    [PFInstallation currentInstallation][@"age"] = age;
    [PFInstallation currentInstallation][@"gender"] = gender;
    [[PFInstallation currentInstallation] saveInBackground];
}

- (IBAction)updateAgeLabel:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    self.ageLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:(int)self.ageControl.value]];
}

- (void)loadInstallData {
    NSNumber *age = [PFInstallation currentInstallation][@"age"];
    NSString *gender = [PFInstallation currentInstallation][@"gender"];

    // Handle saved age, or populate default age.
    if (!age) {
        age = @(35);
        [PFInstallation currentInstallation][@"age"] = age;
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@", age];
    self.ageControl.value = [age floatValue];
    
    // Handle saved gender, or populate default gender.
    if ([gender isEqualToString:@"male"]) {
        self.genderControl.selectedSegmentIndex = 0;
    } else if ([gender isEqualToString:@"female"]) {
        self.genderControl.selectedSegmentIndex = 1;
    } else {
        self.genderControl.selectedSegmentIndex = 0;
        [PFInstallation currentInstallation][@"gender"] = @"male";
    }
    
    [[PFInstallation currentInstallation] saveInBackground];
}

@end
