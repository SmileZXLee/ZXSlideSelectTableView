//
//  ZXSlideSelectTableView.m
//  ZXSlideSelectTableView
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//  https://github.com/SmileZXLee/ZXSlideSelectTableView
//  基于ZXTableView https://github.com/SmileZXLee/ZXTableView

#import "ZXSlideSelectTableView.h"
#import "NSObject+ZXTbSafeValue.h"
#import "NSObject+ZXSlideSelectTableViewKVO.h"
@interface ZXSlideSelectTableView()<UIGestureRecognizerDelegate>
@property(weak,nonatomic)UIView *zx_gestureView;
@property(strong,nonatomic)NSIndexPath *lastSelectedIndexPath;

@end
@implementation ZXSlideSelectTableView

#pragma mark - 初始化
- (void)setZXSlideSelectTableView{
    UIView *gestureView = [[UIView alloc]init];
    [self addSubview:gestureView];
    self.zx_gestureView = gestureView;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.zx_gestureView addGestureRecognizer:panRecognizer];
    [self.zx_gestureView addGestureRecognizer:tapRecognizer];
    __weak typeof(self) weakSelf = self;
    [self zx_obsKey:@"contentSize" handler:^(id  _Nonnull newData, id  _Nonnull oldData, id  _Nonnull owner) {
        if(!CGRectEqualToRect(weakSelf.zx_gestureViewFrame, CGRectZero)){
            weakSelf.zx_gestureView.frame = CGRectMake(weakSelf.zx_gestureViewFrame.origin.x, weakSelf.zx_gestureViewFrame.origin.y, weakSelf.zx_gestureViewFrame.size.width, weakSelf.contentSize.height);
            return;
        }
        if(weakSelf.zx_gestureViewWidth != 0){
            weakSelf.zx_gestureView.frame = CGRectMake(0, 0, self.zx_gestureViewWidth, weakSelf.contentSize.height);
            return;
        }
        weakSelf.zx_gestureView.frame = CGRectMake(0, 0, 50, weakSelf.contentSize.height);
    }];
}
#pragma mark - 生命周期
- (instancetype)init{
    if (self = [super init]) {
        [self setZXSlideSelectTableView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        [self setZXSlideSelectTableView];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setZXSlideSelectTableView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
#pragma mark - Private
#pragma mark gestureViewPan手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.zx_gestureView];
    [self handelGestureWithPoint:CGPointMake(point.x, point.y)];
    if(recognizer.state == UIGestureRecognizerStateEnded){
        self.lastSelectedIndexPath = nil;
    }
}
#pragma mark gestureViewTap手势
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    [self handelGestureWithPoint:CGPointMake(point.x, point.y)];
    if(recognizer.state == UIGestureRecognizerStateEnded){
        self.lastSelectedIndexPath = nil;
    }
}

#pragma mark 处理gestureViewPan手势
- (void)handelGestureWithPoint:(CGPoint)point{
    NSIndexPath *selectedIndexPath = [self indexPathForRowAtPoint:point];
    if((!self.lastSelectedIndexPath || ![selectedIndexPath isEqual:self.lastSelectedIndexPath]) && selectedIndexPath){
        id selectedModel = [self performSelector:@selector(getModelAtIndexPath:) withObject:selectedIndexPath];
        id selectedValue = [selectedModel zx_safeValueForKey:self.zx_modelSelectedKey];
        if(!selectedValue)return;
        if(self.zx_disableAutoSelected){
            [selectedModel zx_safeSetValue:@(1) forKey:self.zx_modelSelectedKey];
        }else{
            [selectedModel zx_safeSetValue:@(![selectedValue boolValue]) forKey:self.zx_modelSelectedKey];
        }
        
        if(self.zx_selectedBlock){
            self.zx_selectedBlock(selectedIndexPath, selectedValue);
        }
        [self reloadData];
    }
    self.lastSelectedIndexPath = selectedIndexPath;
}

#pragma mark - Public
#pragma mark 选中所有项
- (void)zx_selectAll{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __weak typeof(self) weakSelf = self;
        [self zx_enumModelsCallBack:^(id  _Nonnull model, BOOL * _Nonnull stop) {
            [model zx_safeSetValue:@1 forKey:weakSelf.zx_modelSelectedKey];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.zx_selectedBlock){
                self.zx_selectedBlock(nil,nil);
            }
            [self reloadData];
        });
    });
}

#pragma mark 取消所有选中项
- (void)zx_unSelectAll{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __weak typeof(self) weakSelf = self;
        [self zx_enumModelsCallBack:^(id  _Nonnull model, BOOL * _Nonnull stop) {
            [model zx_safeSetValue:@0 forKey:weakSelf.zx_modelSelectedKey];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.zx_selectedBlock){
                self.zx_selectedBlock(nil,nil);
            }
            [self reloadData];
        });
    });
}

#pragma mark 遍历获取所有model
- (void)zx_enumModelsCallBack:(kEnumEventHandler)result{
    BOOL stop = NO;
    if([self performSelector:@selector(isMultiDatas)]){
        for(NSArray *sectionArr in self.zxDatas){
            for (id model in sectionArr) {
                result(model,&stop);
                if(stop)break;
            }
            if(stop)break;
        }
    }else{
        for (id model in self.zxDatas) {
            result(model,&stop);
            if(stop)break;
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)zx_selectedArray{
    _zx_selectedArray = [self getSelectedArray:YES];
    return _zx_selectedArray;
}

- (NSMutableArray *)zx_unSelectedArray{
    _zx_unSelectedArray = [self getSelectedArray:NO];
    return _zx_unSelectedArray;
}

- (NSMutableArray *)getSelectedArray:(BOOL)selected{
    if(!self.zxDatas.count){
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    NSMutableArray *tempSelectedArr = [NSMutableArray array];
    [self zx_enumModelsCallBack:^(id  _Nonnull model, BOOL * _Nonnull stop) {
        id selectedValue = [model zx_safeValueForKey:weakSelf.zx_modelSelectedKey];
        if([selectedValue boolValue] && selected){
            [tempSelectedArr addObject:selectedValue];
        }
        if(![selectedValue boolValue] && !selected){
            [tempSelectedArr addObject:selectedValue];
        }
    }];
    return tempSelectedArr;
}

- (NSString *)zx_modelSelectedKey{
    if(!_zx_modelSelectedKey){
        _zx_modelSelectedKey = @"selected";
    }
    return _zx_modelSelectedKey;
}
@end
