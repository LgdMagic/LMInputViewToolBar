//
//  ViewController.m
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import "ViewController.h"
#import "LMInputViewToolBar.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[LMInputViewToolBar shareToolBar] showInputView];
}

- (IBAction)hideInputView:(id)sender
{
    [LMInputViewToolBar shareToolBar].inputTextView.internalTextView.text = @"";
  
    [self.view endEditing:YES];
    
}

@end
