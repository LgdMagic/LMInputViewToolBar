//
//  LMInputViewToolBar.h
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "LMFaceImgEntry.h"

@interface LMInputViewToolBar : UIView

@property(nonatomic ,strong) HPGrowingTextView *inputTextView;
@property(nonatomic ,strong) UIView *bottomView;
@property(nonatomic ,strong) LMFaceImgEntry *faceEntry;
@property (nonatomic, assign) BOOL needShowInputView;
+ (LMInputViewToolBar *)shareToolBar;

@end
