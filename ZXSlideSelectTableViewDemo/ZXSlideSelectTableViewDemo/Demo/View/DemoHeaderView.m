//
//  DemoHeaderView.m
//  ZXSlideSelectTableViewDemo
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//  https://github.com/SmileZXLee/ZXSlideSelectTableView

#import "DemoHeaderView.h"
@interface DemoHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;
//只需要定义section属性，ZXTableView就会自动赋值，重写其set方法即可
@property (strong, nonatomic)NSNumber *section;
@end
@implementation DemoHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];;
}

- (void)setSection:(NSNumber *)section{
    _section = section;
    self.headerViewLabel.text = [NSString stringWithFormat:@"Section %@",section];
}
@end
