//
//  NSObject+ZXSlideSelectTableViewKVO.m
//  ZXSlideSelectTableView
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//  https://github.com/SmileZXLee/ZXSlideSelectTableView
//  基于ZXTableView https://github.com/SmileZXLee/ZXTableView

#import "NSObject+ZXSlideSelectTableViewKVO.h"

@implementation NSObject (ZXSlideSelectTableViewKVO)
-(void)zx_obsKey:(NSString *)key handler:(obsResultHandler)handler{
    [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:CFBridgingRetain([handler copy])];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if(object == self){
        obsResultHandler handler = (__bridge obsResultHandler)context;
        handler(change[@"new"],change[@"old"],self);
    }
}
@end
