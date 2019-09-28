//
//  DemoModel.h
//  ZXSlideSelectTableViewDemo
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoModel : NSObject
@property(copy, nonatomic) NSString *msg;
//用来记录当前cell的选中状态，若此属性不为“selected”，请修改ZXSlideSelectTableView中的zx_modelSelectedKey为当前属性属性名
@property(assign, nonatomic) BOOL selected;
@end

NS_ASSUME_NONNULL_END
