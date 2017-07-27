//
//  LMFaceImgEntry.h
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYTextView.h>

typedef NS_ENUM(NSInteger, LMFaceEntryReturnType) {
    /**
     *
     */
    LMFaceEntryReturnTypeNormal = 1,
    /**
     *
     */
    LMFaceEntryReturnTypeOther = 2,
};

@class LMFaceImgEntry;

@protocol LMFaceImgEntryDelegate <NSObject>

@required

- (YYTextView *)targetViewForfaceImgEntry;
- (void)faceKeyBoardDidClickedSend;
- (void)writeText;

@optional
- (void)faceKeyBoardDidClickedDelete;
- (void)faceKeyBoardDidClickedFaceWithFaceName:(NSString *)faceName;

@end

@interface LMFaceImgEntry : UIImageView

@property (nonatomic, weak) id<LMFaceImgEntryDelegate> delegate;
@property (nonatomic, assign) LMFaceEntryReturnType returnType;

@end
