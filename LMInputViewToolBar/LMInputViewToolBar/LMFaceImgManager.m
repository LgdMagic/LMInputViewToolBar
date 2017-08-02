//
//  LMFaceImgManager.m
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import "LMFaceImgManager.h"
#import "YYTextAttribute.h"
#import "NSAttributedString+YYText.h"

@interface LMFaceImgManager ()
@property (nonatomic, strong) NSRegularExpression *regex;
@end

@implementation LMFaceImgManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(instancetype)share
{
    static LMFaceImgManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[LMFaceImgManager alloc] init];
    });
    return m;
}

- (NSRegularExpression *)regex{
    if (!_regex) {
        NSString *pattern = @"\\[.*?\\]";
        _regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    }
    return _regex;
}

- (NSArray *)faceDescribeArr{
    if (!_faceDescribeArr) {
        _faceDescribeArr = @[@"[微笑]", @"[撇嘴]", @"[色]", @"[发呆]", @"[得意]",
                             @"[流泪]", @"[害羞]", @"[闭嘴]", @"[睡]", @"[大哭]", @"[尴尬]", @"[发怒]", @"[调皮]", @"[龇牙]", @"[惊讶]", @"[难过]",
                             @"[酷]", @"[冷汗]", @"[抓狂]", @"[可爱]", @"[吐]", @"[偷笑]", @"[白眼]", @"[傲慢]", @"[饥饿]", @"[困]", @"[惊恐]",
                             @"[流汗]", @"[憨笑]", @"[大兵]", @"[奋斗]", @"[咒骂]", @"[疑问]", @"[嘘…]", @"[晕]", @"[折磨]", @"[衰]", @"[骷髅]",
                             @"[敲打]", @"[再见]", @"[擦汗]", @"[抠鼻]", @"[鼓掌]", @"[糗大了]", @"[坏笑]", @"[左哼哼]", @"[右哼哼]", @"[哈欠]",
                             @"[鄙视]", @"[委屈]", @"[快哭了]", @"[阴险]", @"[亲亲]", @"[吓]", @"[可怜]", @"[菜刀]", @"[西瓜]", @"[啤酒]", @"[篮球]",
                             @"[乒乓球]", @"[咖啡]", @"[饭]", @"[玫瑰]", @"[凋谢]", @"[示爱]", @"[爱心]", @"[心碎]", @"[蛋糕]", @"[闪电]", @"[炸弹]",
                             @"[刀]", @"[足球]", @"[瓢虫]", @"[便便]", @"[月亮]", @"[太阳]", @"[礼物]", @"[拥抱]", @"[强]", @"[弱]", @"[握手]",@"[胜利]",@"[抱拳]",
                             @"[勾引]",@"[拳头]",@"[小拇指]",@"[哦耶]",@"[不行]",@"[OK]"];
    }
    return _faceDescribeArr;
}

- (NSMutableAttributedString *)faceAttributedStringWithString:(NSString *)string{
    
    NSMutableAttributedString * strAtt = [[NSMutableAttributedString alloc] initWithString:string];
    NSArray * result = [self.regex matchesInString:strAtt.string options:NSMatchingReportCompletion range:NSMakeRange(0, strAtt.string.length)];
    
    for (NSInteger i = result.count - 1; i >= 0; i--)
    {
        NSTextCheckingResult * r = result[i];
        NSRange range = r.range;
        NSString *targetString = [string substringWithRange:range];
        NSInteger faceIndex = [self.faceDescribeArr indexOfObject:targetString];
        if (faceIndex>=0&&faceIndex<89)  {
            NSTextAttachment * textAtt = [[NSTextAttachment alloc] init];
            textAtt.image = [UIImage imageNamed:[NSString stringWithFormat:@"q_%ld",faceIndex+1]];
            textAtt.bounds = CGRectMake(0, -5, 21, 21);
            NSAttributedString * strImage = [NSAttributedString attributedStringWithAttachment:textAtt];
            [strAtt replaceCharactersInRange:range withAttributedString:strImage];
        }
    }
    return strAtt;
}

- (NSMutableAttributedString *)faceAttributedStringWithAttributedString:(NSAttributedString *)string{
    
    NSMutableAttributedString * strAtt = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    NSArray * result = [self.regex matchesInString:strAtt.string options:NSMatchingReportCompletion range:NSMakeRange(0, strAtt.string.length)];
    
    for (NSInteger i = result.count - 1; i >= 0; i--)
    {
        NSTextCheckingResult * r = result[i];
        NSRange range = r.range;
        NSString *targetString = [string.string substringWithRange:range];
        NSInteger faceIndex = [self.faceDescribeArr indexOfObject:targetString];
        if (faceIndex>=0&&faceIndex<89) {
            NSTextAttachment * textAtt = [[NSTextAttachment alloc] init];
            textAtt.image = [UIImage imageNamed:[NSString stringWithFormat:@"q_%ld",faceIndex+1]];
            textAtt.bounds = CGRectMake(0, -5, 21, 21);
            NSAttributedString * strImage = [NSAttributedString attributedStringWithAttachment:textAtt];
            [strAtt replaceCharactersInRange:range withAttributedString:strImage];
        }
    }
    return strAtt;
}

- (NSMutableAttributedString *)yy_faceAttributedStringWithAttributedString:(NSAttributedString *)string{
    
    NSMutableAttributedString * strAtt = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    NSArray * result = [self.regex matchesInString:strAtt.string options:NSMatchingReportCompletion range:NSMakeRange(0, strAtt.string.length)];
    
    for (NSInteger i = result.count - 1; i >= 0; i--)
    {
        NSTextCheckingResult * r = result[i];
        NSRange range = r.range;
        NSString *targetString = [string.string substringWithRange:range];
        NSInteger faceIndex = [self.faceDescribeArr indexOfObject:targetString];
        if (faceIndex>=0&&faceIndex<89)  {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"q_%ld",faceIndex+1]];
            if (img) {
                UIFont *font = string.yy_font;
                NSMutableAttributedString *attaStr = [NSMutableAttributedString yy_attachmentStringWithContent:img contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(font.pointSize + 4, font.pointSize + 4) alignToFont:string.yy_font alignment:YYTextVerticalAlignmentTop];
                [strAtt replaceCharactersInRange:range withAttributedString:attaStr];
            }
        }
    }
    return strAtt;
}

@end
