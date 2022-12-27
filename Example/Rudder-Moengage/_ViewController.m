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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)flush:(id)sender {
  [[RSClient sharedInstance] flush];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
