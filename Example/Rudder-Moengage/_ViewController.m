//
//  _ViewController.m
//  Rudder-Moengage
//
//  Created by Ruchira on 10/28/2020.
//  Copyright (c) 2020 Ruchira. All rights reserved.
//

#import "_ViewController.h"
#import <Rudder/Rudder.h>

@interface _ViewController ()

@end

@implementation _ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButtonTap:(UIButton *)sender {
    switch (sender.tag) {
        case 0: {
            [[RSClient sharedInstance] identify:@"test_user_id"];
            break;
        case 1: {
            NSDate *birthday = [[NSDate alloc] init];
            [[RSClient sharedInstance] identify:@"test_user_id" traits: @{
                @"birthday": birthday,
                @"address": @{
                    @"city": @"Kolkata",
                    @"country": @"India"
                },
                @"firstname": @"First",
                @"lastname": @"Last",
                @"name": @"Rudder-Bugsnag iOS",
                @"gender": @"Male",
                @"phone": @"0123456789",
                @"email": @"test@gmail.com",
                @"key-1": @"value-1",
                @"key-2": @1234
            }]; //New User 2  test_userid_ios
        }
            break;
        case 2:
            [[RSClient sharedInstance] track:@"New Track event"];
            break;
        case 3:
            [[RSClient sharedInstance] track:@"New Track event" properties:@{
                @"key_1" : @"value_1",
                @"key_2" : @"value_2"
            }];
                break;
        case 4:
            [[RSClient sharedInstance] alias:@"test_user_id"];
            break;
        }
    }
}

@end
