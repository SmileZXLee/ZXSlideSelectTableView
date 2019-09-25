//
//  DemoHeaderView.m
//  ZXSlideSelectTableViewDemo
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "DemoHeaderView.h"
@interface DemoHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;
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