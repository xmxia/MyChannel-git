//
//  ChannelView.m
//  MyChannel
//
//  Created by Apple on 2018/5/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ChannelView.h"
#import "HeaderView.h"
#import "ReactiveObjC.h"
#import "ChannelModel.h"

#define HN_STATUS_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812 ? 44 : 20)
#define MYCHANNEL_FRAME(i) CGRectMake(itemSpace + (i % column)* (_labelWidth + itemSpace), CGRectGetMaxY(wself.header1_frame) + lineSpace + (i / column)*(labelHeight + lineSpace), _labelWidth, labelHeight)

#define RECOMMEND_FRAME(i) CGRectMake(itemSpace + (i % column) * (_labelWidth + itemSpace), CGRectGetMaxY(wself.divisionModel.frame) + wself.header1_frame.size.height + lineSpace + (i / column)*(labelHeight + lineSpace) ,_labelWidth,labelHeight )


static CGFloat itemSpace = 10;
static CGFloat lineSpace = 10;
static int column = 4;
static CGFloat labelHeight = 40;
@interface ChannelView()
{
    
}
@property (nonatomic , strong)NSMutableArray *myChannelArr;
@property (nonatomic , strong)NSMutableArray *recommendChannelArr;
@property (nonatomic , strong)dispatch_queue_t queue;
@property (nonatomic , strong)NSMutableArray *datas;
@property (nonatomic , assign)CGFloat labelWidth;
@property  (nonatomic,strong)HeaderView *header1;
@property (nonatomic,strong)HeaderView *header2;

@property (nonatomic , assign)CGRect header1_frame;

@property (nonatomic , weak)ChannelModel *divisionModel;
@property (nonatomic , strong)ChannelModel *lastModel;
@property (nonatomic ,assign)int divisionIndex;

@end

@implementation ChannelView




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, HN_STATUS_BAR_HEIGHT,self.width , self.height);
    }];
}

-(void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.height, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _myChannelArr = [[NSMutableArray alloc]initWithArray:@[
                                                               @"推荐",@"热点",@"北京",@"视频",
                                                               @"社会",@"图片",@"娱乐",@"问答",
                                                               @"科技",@"汽车",@"财经",@"军事",
                                                               @"体育",@"段子",@"国际",@"趣图",
                                                               @"健康",@"特卖",@"房产",@"小说",
                                                               @"时尚",@"直播",@"育儿",@"搞笑",
                                                               ]];
        _recommendChannelArr = [[NSMutableArray alloc]initWithArray:@[
                                                                      @"历史",@"数码",@"美食",@"养生",
                                                                      @"电影",@"手机",@"旅游",@"宠物",
                                                                      @"情感",@"家具",@"教育",@"三农",
                                                                      @"孕产",@"文化",@"游戏",@"股票",
                                                                      @"科学",@"动漫",@"故事",@"收藏",
                                                                      @"精选",@"语录",@"星座",@"美图",
                                                                      @"辟谣",@"中国新唱将",@"微头条",@"正能量",
                                                                      @"互联网法院",@"彩票",@"快乐男声",@"中国好表演",
                                                                      @"传媒"
                                                                      ]];
        
        _labelWidth = (self.width -(column + 1)*itemSpace) / column;
        
        [self setUI];
        self.backgroundColor = [UIColor whiteColor];
        _datas = [NSMutableArray array];
        _queue = dispatch_queue_create("com.MyChannel.queue", DISPATCH_QUEUE_SERIAL);
      
//        dispatch_queue_create("com.headlineNews.queue", DISPATCH_QUEUE_SERIAL);
        [self configDatas];
    }
    return  self;
}
-(void)setUI
{
    _header1 = [[HeaderView alloc]initWithTitle:@"我的频道" subTitle:@"点击进入频道" needEditBtn:true];
    _header1.frame = CGRectMake(0, 40, self.frame.size.width, 54);
    [self addSubview:_header1];
  __weak typeof(self) weakSelf = self;
    weakSelf.header1.callBack = ^(BOOL selected) {
        [weakSelf refreshEidtBtnWithStatus:selected];
    };
    _header2 = [[HeaderView alloc]initWithTitle:@"推荐频道" subTitle:@"点击添加频道" needEditBtn:false];
    _header2.hidden = YES;
    _header2.frame = _header2.bounds;
    [self addSubview:_header2];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"close_sdk_login_14x14_@2x"] forState:UIControlStateNormal];
    [self addSubview:btn];
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self hide];
    }];
      _header1_frame = self.header1.frame;
}
-(void)configDatas
{

    dispatch_async(_queue, ^{
        for (int i = 0; i < self.myChannelArr.count; i++) {
            ChannelModel *model = [[ChannelModel alloc]init];
            model.name = self.myChannelArr[i];
            model.isMyChannel = true;
            [self.datas addObject:model];
        }
        for (int i = 0 ; i < self.recommendChannelArr.count; i++) {
            ChannelModel *model = [[ChannelModel alloc]init];
            model.name = self.recommendChannelArr[i];
            model.isMyChannel = NO;
            [self.datas addObject:model];
        }
        [self refreshFrames];
        
    });
}
- (void)refreshFrames {
    __weak typeof(self) wself = self;
    
    for (int i = 0 ; i < wself.datas.count; i++) {
        ChannelModel *model = wself.datas[i]; // model.tag 等于btn的tag 且为该数组中元素的下标
        model.tag = i;
        if (model.isMyChannel) {
            model.frame = MYCHANNEL_FRAME(i);
            wself.divisionModel = model;
        }
    }
//
    dispatch_async(dispatch_get_main_queue(), ^{
        wself.header2.top = CGRectGetMaxY(wself.divisionModel.frame) + lineSpace;
        wself.header2.hidden = NO;
    });
//
    for (int i = 0 ; i < wself.datas.count; i++) {
        ChannelModel *model = wself.datas[i];
        if (!model.isMyChannel) {
            int index = i - wself.divisionModel.tag - 1; // 从0开始tag
            model.frame = RECOMMEND_FRAME(index);
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for (ChannelModel *model in wself.datas) {
            CButton *btn = [[CButton alloc]init];
            btn.model = model;
            
            btn.myChannelHandle = ^(CButton *btn) {
                if (!btn.deleImageView.hidden) {
                    [wself removeBtn:btn];
                }
            };
            btn.recommondHandle = ^(CButton *btn) {
                    [wself addBtn:btn];
            };
            btn.beginBtn = ^(CButton *btn) {
                [self addSubview:btn];
            };
            btn.changeBtn = ^(CButton *btn, UIGestureRecognizer *ges) {
                [wself adjustCenterForBtn:btn withGes:ges];
            };
            btn.endBtn = ^(CButton *btn) {
                [self resetBtn:btn];
            };

            [wself addSubview:btn];
            if (btn.model.name.length > 2) {
                btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            }
            if (model.tag == wself.datas.count - 1) {
                wself.contentSize = CGSizeMake(0, CGRectGetMaxY(model.frame) + 30);
            }
//            CButton *button = [[HNButton alloc]initWithMyChannelHandleBlock:^(HNButton *btn) {
//                if (!btn.deleImageView.hidden) {
//                    [wself removeBtn:btn];
                }
//            } recommondChannelHandleBlock:^(HNButton *btn) {
//                [wself addBtn:btn];
//            }];
//
//            [button addLongPressBeginBlock:^(HNButton *btn) {
//                [wself addSubview:btn];
//            } longPressMoveBlock:^(HNButton *btn, UILongPressGestureRecognizer *ges) {
//                [wself adjustCenterForBtn:btn withGes:ges];
//            } longPressEndBlock:^(HNButton *btn) {
//                [wself resetBtnFrame:btn];
//            }];
//
//            button.model = model;
//            if (button.model.name.length > 2) {
//                button.titleLabel.adjustsFontSizeToFitWidth = YES;
//            }
//            if (model.tag == wself.datas.count - 1) {
//                wself.contentSize = CGSizeMake(0, CGRectGetMaxY(model.frame) + 30);
//            }
//            [wself addSubview:button];
//        }
    });
}
-(void)addBtn:(CButton *)btn
{
    __weak typeof(self) wself = self;
    [self.datas removeObject:btn.model];
    
    [self.datas insertObject:btn.model atIndex:self.divisionModel.tag+1];
    btn.model.isMyChannel = true;
    int divisionIndex = self.divisionModel.tag+1;
    BOOL editBtnSelected = self.header1.editBtn.selected;
    for (int i = 0; i < self.datas.count; i++) {
        ChannelModel *model = self.datas[i];
        model.tag = i;
        if (model.isMyChannel) {
            model.frame = MYCHANNEL_FRAME(i);
            model.hideDeleBtn = editBtnSelected ? NO : YES;
        }else{
            int index = i - divisionIndex -1;
            model.frame = RECOMMEND_FRAME(index);
            model.hideDeleBtn = true;
        }
        if (i == divisionIndex) {
            self.divisionModel = model;
        }
        
    }
    [self refreshBtn];
    
    
}
-(void)removeBtn:(CButton *)btn
{
    __weak typeof(self) wself = self;
    ChannelModel *model = btn.model;
    [self.datas removeObject:model];
    [self.datas insertObject:model atIndex:self.divisionModel.tag];
    model.isMyChannel = false;
    int divisionIndex = self.divisionModel.tag - 1;
    
    dispatch_async(_queue, ^{
        if (divisionIndex == -1){
           _lastModel = [[ChannelModel alloc]init];
            _lastModel.frame = MYCHANNEL_FRAME(0);
            _lastModel.tag = -1;
            self.divisionModel = _lastModel;
        }
        for (int i = 0; i < self.datas.count; i++) {
            ChannelModel *model = self.datas[i];
            model.tag = i;
            if (model.isMyChannel) {
                model.frame = MYCHANNEL_FRAME(i);
                model.hideDeleBtn = NO;
            }else {
                if (divisionIndex == -1) {
                    model.frame = RECOMMEND_FRAME(i);
                    model.hideDeleBtn = YES;
                }else{
                int index = i - self.divisionModel.tag - 1;
                model.frame = RECOMMEND_FRAME(index);
                model.hideDeleBtn = YES;
                }
            }
            if (i == divisionIndex) {
                self.divisionModel = model;
            }
            
            
            [self refreshBtn];
        }
    });
}


-(void)adjustCenterForBtn:(CButton *)btn withGes:(UIGestureRecognizer*)ges
{
    
    CGPoint location = [ges locationInView:self];
    btn.center = location;
    ChannelModel *targetModel;
    for (ChannelModel *model in self.datas) {
        if (model.isMyChannel) {
            if (CGRectContainsPoint(model.frame, location)) {
                targetModel = model;
        
            }
        }
    }
    if (targetModel) {
        if (targetModel == self.divisionModel) {
           _divisionModel = targetModel;
        }else if (btn.model == self.divisionModel){
            _divisionModel = self.datas[btn.model.tag - 1];
        }
    [self.datas removeObject:btn.model];
    [self.datas insertObject:btn.model atIndex:targetModel.tag];
    __weak typeof(self) wself = self;
    for (int i = 0; i < self.datas.count; i++) {
        ChannelModel *model = self.datas[i];
        model.tag = i;
        if (model.isMyChannel && model != btn.model) {
            model.frame = MYCHANNEL_FRAME(i);
        }
    }
        dispatch_async(dispatch_get_main_queue(), ^{
        
            for (int i = 0; i < self.datas.count; i++) {
                ChannelModel *model = self.datas[i];
                if (model.isMyChannel && model != btn.model) {
                    [UIView animateWithDuration:0.25 animations:^{
                        model.btn.frame = model.frame;
                    }];
                    
                }
            }
            
            
        });
    }
}

-(void)resetBtn:(CButton*)btn
{
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            btn.frame = MYCHANNEL_FRAME(btn.model.tag);
        }];
        
        
    });
    
    
    
    
    
}


-(void)refreshBtn
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (ChannelModel *model in self.datas) {
            [UIView animateWithDuration:0.25 animations:^{
                model.btn.frame = model.frame;
            }];
            model.btn.deleImageView.hidden = model.hideDeleBtn;
            [model.btn reloadData];
            
        }
        
        
        
        
    });
}


- (void)setDivisionModel:(ChannelModel *)divisionModel {
    _divisionModel = divisionModel;
//    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshHeader2Frame];
        });
//    }else {
//        [self refreshHeader2Frame];
//    }

}
- (void)refreshHeader2Frame {
    if (self.header2.hidden) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.header2.frame = CGRectMake(0, CGRectGetMaxY(self.divisionModel.frame)+lineSpace, self.frame.size.width, 54);
    }];
}


- (void)refreshEidtBtnWithStatus:(BOOL)show {
    __weak typeof(self) wself = self;
    if (!show) {
        for (CButton *btn in wself.subviews) {
            if (![btn isKindOfClass:[CButton class]]) continue;
            if (btn.model.isMyChannel) {
                btn.deleImageView.hidden = YES;
            }else {
                btn.deleImageView.hidden = YES;
            }
        }
    }else {
        for (CButton *btn in wself.subviews) {
            if (![btn isKindOfClass:[CButton class]]) continue;
            if (btn.model.isMyChannel) {
                btn.deleImageView.hidden = NO;
            }else {
                btn.deleImageView.hidden = YES;
            }
        }
    }
    
}
-(void)dealloc
{
    NSLog(@"realse");
}

@end
