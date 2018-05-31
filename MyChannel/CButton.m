//
//  CButton.m
//  MyChannel
//
//  Created by Apple on 2018/5/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "CButton.h"
#import "Masonry.h"
@implementation CButton
#define HN_MIAN_GRAY_Color [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1]
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"closeicon_repost_18x18_"]];
        _deleImageView = imageView;
        [self addSubview:_deleImageView];
        [_deleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(18);
            make.right.top.mas_equalTo(self);
        }];
        imageView.hidden = YES;
        [self addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        [self addGestureRecognizer:longPress];
        self.layer.cornerRadius = 4;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}
// 设置按钮的阴影路径 --> 提高效率
static UIBezierPath * pathForBtn(CButton *btn) {
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = btn.bounds.size.width;
    float height = btn.bounds.size.height;
    float x = btn.bounds.origin.x;
    float y = btn.bounds.origin.y;
    float addWH = 2;
    
    CGPoint topLeft      = btn.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    [path moveToPoint:topLeft];
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    return path;
}
static inline void configMyChannelBg(CButton *btn){
    btn.backgroundColor = HN_MIAN_GRAY_Color;
    btn.layer.shadowOffset =  CGSizeMake(0, 0);
    btn.layer.shadowColor =  [UIColor clearColor].CGColor;
    btn.layer.shadowPath = nil;
}
static inline void configRecommondBg(CButton *btn){
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.shadowOffset =  CGSizeMake(1, 1);
    btn.layer.shadowOpacity = 0.2;
    btn.layer.shadowColor =  [UIColor blackColor].CGColor;
    btn.layer.shadowPath = pathForBtn(btn).CGPath;
}

- (void)setModel:(ChannelModel *)model {
    _model = model;
    self.frame = model.frame;
    model.btn = self;
    if (model.isMyChannel) {
        [self setTitle:model.name forState:UIControlStateNormal];
        configMyChannelBg(self);
    }else {
        [self setTitle:[NSString stringWithFormat:@"＋%@",model.name] forState:UIControlStateNormal];
        configRecommondBg(self);
    }
}

-(void)btnclick:(UIButton*)sender
{
    if (self.model.isMyChannel) {
        if (_myChannelHandle) {
            _myChannelHandle(self);
        }
    }else{
        if (_recommondHandle) {
            _recommondHandle(self);
        }
    }
}
-(void)btnLong:(UIGestureRecognizer *)ges
{
    if (self.model.isMyChannel == NO || self.deleImageView.hidden == true) {
        return;
    }
    if (ges.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [ges locationInView:self.superview];
//        CGPoint center = self.center;
        [UIView animateWithDuration:0.25 animations:^{
            self.height += 10;
            self.width += 8;
            self.center = location;
        }];
        if (_beginBtn) {
            _beginBtn(self);
        }
    }else if(ges.state == UIGestureRecognizerStateChanged) {
        if (_changeBtn) {
            _changeBtn(self,ges);
        }
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed){
        if (_endBtn) {
            _endBtn(self);
        }
    }
}

-(void)reloadData
{
    if (self.model.isMyChannel) {
        [self setTitle:self.model.name forState:UIControlStateNormal];
        configMyChannelBg(self);
    }else{
        [self setTitle:[NSString stringWithFormat:@"+%@",self.model.name] forState:UIControlStateNormal];
        configRecommondBg(self);
    }
}


@end
