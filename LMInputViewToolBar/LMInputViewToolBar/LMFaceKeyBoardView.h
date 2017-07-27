//
//  LMFaceKeyBoardView.h
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMFaceImgEntry.h"
#define GrayColor [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ToolBarHeight 26

typedef void (^FaceKeyBoardBlock)(NSString * faceName,NSInteger faceTag);
typedef void (^FaceKeyBoardSendBlock)(void);
typedef void (^FaceKeyBoardDeleteBlock)(void);

@interface LMFaceKeyBoardView : UIView

@property (nonatomic, assign) LMFaceEntryReturnType returnType;

- (void)setFaceKeyBoardBlock:(FaceKeyBoardBlock)block;
- (void)setFaceKeyBoardSendBlock:(FaceKeyBoardSendBlock)block;
- (void)setFaceKeyBoardDeleteBlock:(FaceKeyBoardDeleteBlock)block;

@end
