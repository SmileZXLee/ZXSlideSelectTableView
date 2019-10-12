//
//  NSObject+ZXSlideSelectTableViewKVO.m
//  ZXSlideSelectTableView
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//  https://github.com/SmileZXLee/ZXSlideSelectTableView
//  基于ZXTableView https://github.com/SmileZXLee/ZXTableView

#import "NSObject+ZXSlideSelectTableViewKVO.h"
#import <objc/runtime.h>
static NSString *zx_observingKeyPathDictionaryKey = @"zx_observingKeyPathDictionaryKey";
@implementation NSObject (ZXSlideSelectTableViewKVO)
#pragma mark - 生命周期
+ (void)load{
    zx_swizzleMethod(self, NSSelectorFromString(@"dealloc"), @selector(zx_dealloc));
}

- (void)zx_dealloc{
    if(self.zx_observingKeyPathDictionary){
        for (NSString *key in self.zx_observingKeyPathDictionary.allKeys) {
            [self removeObserver:self forKeyPath:key];
        }
    }
    [self zx_dealloc];
}

#pragma mark - getter & setter
- (void)setZx_observingKeyPathDictionary:(NSMutableDictionary *)zx_observingKeyPathDictionary{
    objc_setAssociatedObject(self, &zx_observingKeyPathDictionaryKey, zx_observingKeyPathDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)zx_observingKeyPathDictionary{
    return objc_getAssociatedObject(self, &zx_observingKeyPathDictionaryKey);
}

#pragma mark - Public
-(void)zx_obsKey:(NSString *)key handler:(obsResultHandler)handler{
    [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:(__bridge_retained void *)([handler copy])];
    if(!self.zx_observingKeyPathDictionary){
        self.zx_observingKeyPathDictionary = [NSMutableDictionary dictionary];
    }
    [self.zx_observingKeyPathDictionary setValue:handler forKey:key];
}

#pragma mark - Private
void zx_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod){
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if(object == self){
        obsResultHandler handler = (__bridge obsResultHandler)context;
        handler(change[@"new"],change[@"old"],self);
    }
}
@end
