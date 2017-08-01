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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInputView:(id)sender
{
    if ([[LMInputViewToolBar shareToolBar].inputTextView.internalTextView isFirstResponder]) {
        [[LMInputViewToolBar shareToolBar].inputTextView.internalTextView resignFirstResponder];
        return;
    }

    LMInputViewToolBar *inputToolBar = [LMInputViewToolBar shareToolBar];
    inputToolBar.needShowInputView = YES;
    [inputToolBar.inputTextView becomeFirstResponder];

}

- (IBAction)hideInputView:(id)sender
{
    [LMInputViewToolBar shareToolBar].inputTextView.internalTextView.text = @"";
  
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    
}

@end
