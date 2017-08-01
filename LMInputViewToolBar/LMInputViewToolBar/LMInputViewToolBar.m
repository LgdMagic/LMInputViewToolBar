//
//  LMInputViewToolBar.m
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import "LMInputViewToolBar.h"
#import "HPGrowingTextView.h"
#import "UIColor+Addition.h"
#import <YYCategories.h>

#define SCREEN_WIDTH   [UIScreen mainScreen].applicationFrame.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].applicationFrame.size.height
#define BOTTOM_VIEW_HEIGHT 49
#define NAVI_VIEW_HEIGHT 64

@interface LMInputViewToolBar ()<HPGrowingTextViewDelegate,LMFaceImgEntryDelegate>

@property(nonatomic ,strong) HPGrowingTextView *realInputTextView;
@property(nonatomic ,strong) UILabel *numCountLabel;

@end

static LMInputViewToolBar *_shareToolbar;

@implementation LMInputViewToolBar

+ (LMInputViewToolBar *)shareToolBar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareToolbar = [[LMInputViewToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH
, 49)];
    });
    return _shareToolbar;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addBottmBar];
    }
    return self;
}

-(void)addBottmBar
{
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, BOTTOM_VIEW_HEIGHT);
    _bottomView.backgroundColor = [UIColor colorFromHexString:@"efeff4"];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorFromHexString:@"d8d8dc"];
    [_bottomView addSubview:topLine];
    
    _inputTextView = [[HPGrowingTextView alloc]init];
    _inputTextView.frame = CGRectMake(15, 8, SCREEN_WIDTH - 60, 37);
    _inputTextView.isScrollable = NO;
    _inputTextView.contentInset = UIEdgeInsetsMake(4, 2, 0, 2);
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.layer.cornerRadius = 3;
    _inputTextView.layer.borderWidth = 0.5f;
    _inputTextView.layer.borderColor = [UIColor colorFromHexString:@"e0e0e0"].CGColor;
    _inputTextView.minNumberOfLines = 1;
    _inputTextView.maxNumberOfLines = 5;
    _inputTextView.font = [UIFont systemFontOfSize:15];
    _inputTextView.delegate = self;
    _inputTextView.height = 37;
    _inputTextView.minHeight = 37;
    _inputTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _inputTextView.backgroundColor = [UIColor colorFromHexString:@"ffffff"];
    _inputTextView.placeholderColor = [UIColor colorFromHexString:@"c8c8c8"];
    _inputTextView.placeholder = @"请输入内容";
    _inputTextView.returnKeyType = UIReturnKeySend;
    [_bottomView addSubview:_inputTextView];
    
    _faceEntry = [[LMFaceImgEntry alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    _faceEntry.right = SCREEN_WIDTH-15;
    _faceEntry.centerY = _bottomView.height/2.f;
    _faceEntry.userInteractionEnabled = YES;
    _faceEntry.delegate = self;
    [_bottomView addSubview:_faceEntry];
    
    _numCountLabel = [UILabel new];
    _numCountLabel.frame = CGRectMake(0, 0, 40, 14);
    _numCountLabel.font = [UIFont systemFontOfSize:11];
    _numCountLabel.centerX = _faceEntry.centerX;
    _numCountLabel.bottom = _faceEntry.top-10;
    _numCountLabel.textAlignment = NSTextAlignmentCenter;
    _numCountLabel.hidden = YES;
    [_bottomView addSubview:_numCountLabel];
    
    _inputTextView.width = SCREEN_WIDTH-_faceEntry.width-45;
    _inputTextView.left = 15;
    _inputTextView.centerY = _bottomView.height/2.f;
    
    [[UIApplication sharedApplication].delegate.window addSubview:_bottomView];
    
}

- (void)setNeedShowInputView:(BOOL)needShowInputView{
    _needShowInputView = needShowInputView;
    if (needShowInputView) {
        [self addKeyBoardNotification];
    }
}

#pragma mark -
#pragma mark ======================= inputViewDelegate ============================

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = _bottomView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    _bottomView.frame = r;
    _faceEntry.bottom = _bottomView.height-10;
    _numCountLabel.bottom = _faceEntry.top-10;
}

-(BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
  
 
}

- (YYTextView *)targetViewForfaceImgEntry{
    return self.inputTextView.internalTextView;
}

#pragma faceKeyBoard delegate
- (void)faceKeyBoardDidClickedSend{
    
    self.inputTextView.internalTextView.text = @"";
    [self.inputTextView resignFirstResponder];
}

- (void)faceKeyBoardDidClickedFaceWithFaceName:(NSString *)faceName{
    NSMutableString *text = [NSMutableString stringWithString:self.inputTextView.internalTextView.text];
    NSRange seletR = self.inputTextView.internalTextView.selectedRange;
    [text insertString:faceName atIndex:seletR.location];
    self.inputTextView.internalTextView.text = [text copy];
    [self.inputTextView.internalTextView setSelectedRange:NSMakeRange(seletR.location+faceName.length, 0)];
}

- (void)faceKeyBoardDidClickedDelete{
    if ([self.inputTextView.internalTextView respondsToSelector:@selector(deleteBackward)]) {
        [self.inputTextView.internalTextView performSelector:@selector(deleteBackward) withObject:nil];
    }
}

#pragma mark -
#pragma ========================== 键盘 ===================================

-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:_bottomView];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    _bottomView.hidden = !_needShowInputView;
    if (![_inputTextView.internalTextView isFirstResponder]) {
        [_inputTextView.internalTextView becomeFirstResponder];
    }
    
    _bottomView.bottom = SCREEN_HEIGHT  - keyboardBounds.size.height;
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    _bottomView.hidden = YES;
    _bottomView.top = SCREEN_HEIGHT;
    _needShowInputView = NO;

    [UIView commitAnimations];
}



@end
