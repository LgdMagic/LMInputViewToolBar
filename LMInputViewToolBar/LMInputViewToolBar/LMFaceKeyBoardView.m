//
//  LMFaceKeyBoardView.m
//  LMInputViewToolBar
//
//  Created by guodong liu on 2017/7/27.
//  Copyright © 2017年 yousails. All rights reserved.
//

#import "LMFaceKeyBoardView.h"
#import "LMFaceImgManager.h"
#import <YYCategories.h>
#import "UIView+YYAdd.h"

static ushort const rowNum = 4;

@interface LMFaceKeyBoardView ()<UIScrollViewDelegate>
{
    CGFloat _FKBViewH;
}

@property (nonatomic, strong)NSArray * arrFace;
@property (nonatomic, strong)UIScrollView * scFace;
@property (nonatomic, strong)FaceKeyBoardBlock block;
@property (nonatomic, strong)FaceKeyBoardSendBlock sendBlock;
@property (nonatomic, strong)FaceKeyBoardDeleteBlock deleteBlock;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIButton *sendBtn;
@property (nonatomic, strong)UIPageControl *pageC;

@property (nonatomic, strong)LMFaceImgManager *FManager;
@property (nonatomic, copy)NSArray * faceDescribeArr;
@end

@implementation LMFaceKeyBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setViewFrame];
        [self loadKeyBoardView];
    }
    return self;
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

- (void)setViewFrame
{
    CGFloat marginY = (ScreenWidth - 7 * 30) / (7 + 1);
    CGFloat scViewH = rowNum * (30 + marginY) + marginY*2+5;
    _FKBViewH = scViewH;
    self.frame = CGRectMake(0, ScreenHeight - _FKBViewH, ScreenWidth, _FKBViewH);
}

- (void)loadKeyBoardView
{
    //初始化manager
    self.FManager = [LMFaceImgManager share];
    //获取数据
    [self.FManager fetchAllFaces];
    [self setFaceFrame];
}

- (void)fetchRecentlyFaces
{
    //更新manager
    [self.FManager fetchRecentlyFaces];
    self.arrFace = self.FManager.RecentlyFaces;
    [self setFaceFrame];
}

- (void)fetchAllFaces
{
    self.arrFace = self.FManager.AllFaces;
    //设置表情scrollView
    [self setFaceFrame];
}

- (void)fetchBigFaces
{
    self.arrFace = nil;
    [self setFaceFrame];
}

- (void)setFaceFrame
{
    //列数
    NSInteger colFaces = 7;
    //行数
    NSInteger rowFaces = rowNum;
    //设置face按钮frame
    CGFloat FaceW = 30;
    CGFloat FaceH = 30;
    CGFloat marginX = (ScreenWidth - colFaces * FaceW) / (colFaces + 1);
    CGFloat marginY = marginX;
    
    //表情数量
    NSInteger FaceCount = self.arrFace.count;
    /***************************************/
    FaceCount = 89;
    /***************************************/
    //每页表情数和scrollView页数；
    NSInteger PageFaceCount = colFaces * rowFaces ;
    NSInteger SCPages = FaceCount / PageFaceCount + 1;
    
    CGFloat scViewH = rowFaces * (FaceH + marginY) + marginY*2 + 10;
    //初始化scrollView
    self.scFace = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, scViewH)];
    self.scFace.contentSize = CGSizeMake(ScreenWidth * SCPages, scViewH);
    self.scFace.pagingEnabled = YES;
    self.scFace.bounces = NO;
    self.scFace.delegate = self;
    self.scFace.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scFace];
    //初始化贴在sc上的view
    UIView * BtnView = [[UIView alloc] init];
    BtnView.frame = CGRectMake(0, 0, ScreenWidth * SCPages, scViewH);
    [BtnView setBackgroundColor:GrayColor];
    [self.scFace addSubview:BtnView];
    
    for (NSInteger i = 0; i < FaceCount + SCPages; i ++)
    {
        //当前页数
        NSInteger currentPage = i / PageFaceCount;
        //当前行
        NSInteger rowIndex = i / colFaces - (currentPage * rowFaces);
        //当前列
        NSInteger colIndex = i % colFaces;
        
        //viewW * currentPage换页
        CGFloat btnX = marginX + colIndex * (FaceW + marginX) + ScreenWidth * currentPage;
        CGFloat btnY = rowIndex * (marginY + FaceH) + marginY;
        /*
         if ((i - (currentPage + 1) * (PageFaceCount - 1) == currentPage || i == FaceCount + SCPages - 1) && self.arrFace)
         */
        if ((i - (currentPage + 1) * (PageFaceCount - 1) == currentPage || i == FaceCount + SCPages - 1))
        {
            //创建删除按钮
            CGFloat btnDelteX = (currentPage + 1) * ScreenWidth - (marginX + FaceW);
            CGFloat btnDelteY = (rowNum-1) * (FaceH + marginY) +marginY;
            
            UIButton * btnDelte = [UIButton buttonWithType:UIButtonTypeSystem];
            btnDelte.frame = CGRectMake(btnDelteX, btnDelteY, FaceW, FaceH);
            [btnDelte setBackgroundImage:[UIImage imageNamed:@"q_0"] forState:UIControlStateNormal];
            [btnDelte setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnDelte.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            
            [btnDelte addTarget:self action:@selector(tapDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
            
            [BtnView addSubview:btnDelte];
        }
        
        else
        {
            UIButton * btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(btnX , btnY, FaceW, FaceH);
            btn.tag = i - currentPage;
            [btn addTarget:self action:@selector(tapFaceBtnWithButton:) forControlEvents:UIControlEventTouchUpInside];
            NSString * strIMG = [NSString stringWithFormat:@"q_%ld",i+1-currentPage];
            [btn setImage:[UIImage imageNamed:strIMG] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:strIMG] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
            [BtnView addSubview:btn];
        }
    }
    
    //创建pageController
    [self addSubview:self.pageC];
    //    self.bottomView.centerY = self.pageC.centerY;
    self.bottomView.bottom = self.size.height;
    self.pageC.centerY = self.bottomView.centerY;
    [self addSubview:self.bottomView];
}

//点击表情
- (void)tapFaceBtnWithButton:(UIButton *)button
{
    if (self.faceDescribeArr.count>button.tag) {
        self.block(self.faceDescribeArr[button.tag],button.tag);
    }
}

//点击删除
- (void)tapDeleteBtn
{
    self.deleteBlock();
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.pageC.currentPage = targetContentOffset->x / ScreenWidth;
}

#pragma pageContorl
- (UIPageControl *)pageC{
    if (!_pageC) {
        NSInteger colFaces = 7;
        //行数
        NSInteger rowFaces = rowNum;
        /*********************************************************************************/
        NSInteger FaceCount = self.arrFace.count;
        FaceCount = 89;
        /*********************************************************************************/
        //每页表情数和scrollView页数；
        NSInteger PageFaceCount = colFaces * rowFaces ;
        NSInteger SCPages = FaceCount / PageFaceCount + 1;
        //设置face按钮frame
        CGFloat FaceW = 30;
        CGFloat marginX = (ScreenWidth - colFaces * FaceW) / (colFaces + 1);
        CGFloat pageH = 10;
        CGFloat pageW = ScreenWidth;
        CGFloat pageX = 0;
        CGFloat pageY = self.scFace.height - pageH - marginX;
        self.pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(pageX, pageY, pageW, pageH)];
        self.pageC.numberOfPages = SCPages;
        CGSize pagecSize = [self.pageC sizeForNumberOfPages:SCPages];
        self.pageC.width = pagecSize.width;
        self.pageC.centerX = ScreenWidth/2.f;
        self.pageC.currentPage = 0;
        self.pageC.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageC.currentPageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageC;
}

#pragma 发送
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-ToolBarHeight, ScreenWidth, ToolBarHeight)];
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(0, 0, 65, 30);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
        _sendBtn.right = ScreenWidth;
        _sendBtn.bottom = _bottomView.height;
        [_sendBtn addTarget:self action:@selector(tapSendBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_sendBtn];
    }
    return _bottomView;
}

- (void)setReturnType:(LMFaceEntryReturnType)returnType{
    _returnType = returnType;
    switch (returnType) {
        case 2:
            [_sendBtn setTitle:@"完成" forState:UIControlStateNormal];
            break;
            
        default:
            [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
            break;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tapSendBtn
{
    self.sendBlock?self.sendBlock():nil;
}

- (void)textDidChanged:(NSNotification *)noti{
    NSString *text = noti.object;
    if ([text isKindOfClass:NSString.class]) {
        if (text.length==0) {
            _sendBtn.backgroundColor = [UIColor lightGrayColor];
        }else{
            _sendBtn.backgroundColor = [UIColor blueColor];
        }
    }
    
}


//点击表情接口
- (void)setFaceKeyBoardBlock:(FaceKeyBoardBlock)block
{
    self.block = [block copy];
}
//发送接口
-(void)setFaceKeyBoardSendBlock:(FaceKeyBoardSendBlock)block
{
    self.sendBlock = [block copy];
}
//删除接口
-(void)setFaceKeyBoardDeleteBlock:(FaceKeyBoardDeleteBlock)block
{
    self.deleteBlock = [block copy];
}

@end
