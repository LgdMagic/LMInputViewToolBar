//
//  LMFaceImgEntry.m
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import "LMFaceImgEntry.h"
#import "LMFaceKeyBoardView.h"
#import "NSAttributedString+YYText.h"
#import <YYCategories.h>

@interface LMFaceImgEntry ()
@property (nonatomic, assign) BOOL changeToNormalInputView;//是否切换到文字键盘
@property (nonatomic, weak) YYTextView *targetView;
@property (nonatomic, strong) LMFaceKeyBoardView *keyBoardView;
@property (nonatomic, strong) NSRegularExpression *regex;
@end

@implementation LMFaceImgEntry

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadKeyBoardView];
        NSString *pattern = @"\\[.*?\\]";
        self.regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
        self.image = [UIImage imageNamed:@"ip_brow"];
    }
    return self;
}

- (void)loadKeyBoardView
{
    self.keyBoardView = [LMFaceKeyBoardView new];
    
    @weakify(self);
    //点击表情
    [self.keyBoardView setFaceKeyBoardBlock:^(NSString *faceName, NSInteger faceTag) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(faceKeyBoardDidClickedFaceWithFaceName:)]) {
            [self.delegate faceKeyBoardDidClickedFaceWithFaceName:faceName];
        }else{
            //拼接字符串
            //获取光标的位置
            if ([self.targetView respondsToSelector:@selector(setText:)]) {
                NSMutableString *text = [NSMutableString stringWithString:self.targetView.text];
                NSRange seletR = self.targetView.selectedRange;
                [text insertString:faceName atIndex:seletR.location];
                self.targetView.text = [text copy];
                [self.targetView setSelectedRange:NSMakeRange(seletR.location+faceName.length, 0)];
            }
        }
    }];
    
    //点击发送
    [self.keyBoardView setFaceKeyBoardSendBlock:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(faceKeyBoardDidClickedSend)]) {
            [self.delegate faceKeyBoardDidClickedSend];
        }
    }];
    
    //点击删除
    [self.keyBoardView setFaceKeyBoardDeleteBlock:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(faceKeyBoardDidClickedDelete)]) {
            [self.delegate faceKeyBoardDidClickedDelete];
        }else{
            //删除字符串
            if ([self.targetView respondsToSelector:@selector(deleteBackward)]) {
                [self.targetView performSelector:@selector(deleteBackward) withObject:nil];
            }
        }
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(targetViewForfaceImgEntry)]) {
        _targetView = [self.delegate targetViewForfaceImgEntry];
    }
    if ([self.delegate respondsToSelector:@selector(writeText)]) {
        [self.delegate writeText];
    }
    NSRange seletR = self.targetView.selectedRange;
    [super touchesEnded:touches withEvent:event];
    if (_targetView&&[_targetView respondsToSelector:@selector(setInputView:)]&&[_targetView respondsToSelector:@selector(reloadInputViews)]) {
        //切换图片
        if (_changeToNormalInputView) {
            [_targetView performSelector:@selector(setInputView:) withObject:nil];
            [_targetView performSelector:@selector(reloadInputViews) withObject:nil];
            self.image = [UIImage imageNamed:@"ip_brow"];
        }else {
            [_targetView performSelector:@selector(setInputView:) withObject:self.keyBoardView];
            [_targetView performSelector:@selector(reloadInputViews) withObject:nil];
            self.image = [UIImage imageNamed:@"ip_keyboard"];
        }
        _changeToNormalInputView = !_changeToNormalInputView;
        if ([_targetView canBecomeFirstResponder]&&![_targetView isFirstResponder]) {
            [_targetView becomeFirstResponder];
        }
        [self.targetView setSelectedRange:NSMakeRange(seletR.location, 0)];
    }
}

- (void)targetViewDidChang
{
    [_regex enumerateMatchesInString:self.targetView.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.targetView.text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        if ([self.targetView.attributedText attribute:YYTextBindingAttributeName atIndex:range.location effectiveRange:NULL]) return;
        
        NSRange bindlingRange = NSMakeRange(range.location, range.length);
        YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:NO];
        [self.targetView.attributedText.mutableCopy yy_setTextBinding:binding range:bindlingRange];
    }];
}

@end
