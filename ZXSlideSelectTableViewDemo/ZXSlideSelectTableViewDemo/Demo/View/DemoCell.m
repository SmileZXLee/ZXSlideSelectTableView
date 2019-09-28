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
//只需要定义含有“model”字符串的属性，ZXTableView就会自动赋值，重写其set方法即可
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
