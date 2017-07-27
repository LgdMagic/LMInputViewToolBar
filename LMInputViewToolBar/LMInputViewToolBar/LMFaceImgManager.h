//
//  LMFaceImgManager.h
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMFaceImgManager : NSObject
@property (nonatomic, strong, readonly)NSArray * RecentlyFaces;
@property (nonatomic, strong, readonly)NSArray * AllFaces;
@property (nonatomic, strong, readonly)NSArray * BigFaces;
@property (nonatomic, copy)NSArray * faceDescribeArr;

+ (instancetype)share;
- (NSMutableAttributedString *)faceAttributedStringWithString:(NSString *)string;
- (NSMutableAttributedString *)faceAttributedStringWithAttributedString:(NSAttributedString *)string;
- (NSMutableAttributedString *)yy_faceAttributedStringWithAttributedString:(NSAttributedString *)string;
- (void)fetchRecentlyFaces;
- (void)fetchAllFaces;
@end
