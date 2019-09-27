//
//  DemoCell.m
//  ZXSlideSelectTableViewDemo
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//  https://github.com/SmileZXLee/ZXSlideSelectTableView

#import "DemoCell.h"
#import "DemoModel.h"
@interface DemoCell()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (strong, nonatomic) DemoModel *demoModel;
@end
@implementation DemoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDemoModel:(DemoModel *)demoModel{
    _demoModel = demoModel;
    self.msgLabel.text = demoModel.msg;
    self.selectBtn.selected = demoModel.selected;
}
- (IBAction)selectAction:(id)sender {
    self.demoModel.selected = !self.selectBtn.selected;
    self.selectBtn.selected = self.demoModel.selected;
}

@end
