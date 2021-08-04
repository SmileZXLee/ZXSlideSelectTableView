//
//  DemoVC.m
//  ZXSlideSelectTableViewDemo
//
//  Created by 李兆祥 on 2019/9/25.
//  Copyright © 2019 李兆祥. All rights reserved.
//  https://github.com/SmileZXLee/ZXSlideSelectTableView

#import "DemoVC.h"
#import "ZXSlideSelectTableView.h"
#import "DemoHeaderView.h"
#import "DemoCell.h"
#import "DemoModel.h"
@interface DemoVC ()
@property (weak, nonatomic) IBOutlet ZXSlideSelectTableView *tableView;
@end

@implementation DemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZXSlideSelectTableView";
    [self setTableView];
    [self setDatas];
    [self setSetButtonWithTitle:@"全选"];
}

#pragma mark - Private
#pragma mark 设置tableView
- (void)setTableView{
    //首先需要设置self.tableView.zx_gestureView的frame，即滑动选择手势识别区域的frame，默认为(0,0,50,self.tableView.contentSize.height)，根据项目的真实情况确定是否需要修改，建议通过self.tableView.zx_gestureViewWidth、self.tableView.zx_gestureViewLeft、self.tableView.zx_gestureViewRight、self.tableView.zx_gestureViewTop、self.tableView.zx_gestureViewBottom以及self.tableView.zx_gestureViewFrameBlock修改，不要直接设置frame，因为以上属性会根据tableView的contentSize改变自动调整
    __weak typeof(self) weakSelf = self;
    self.tableView.zx_gestureViewLeft = 0;
    //声明tableView的cell
    self.tableView.zx_setCellClassAtIndexPath = ^Class _Nonnull(NSIndexPath * _Nonnull indexPath) {
        return [DemoCell class];
    };
    //声明tableView的headerView
    self.tableView.zx_setHeaderClassInSection = ^Class _Nonnull(NSInteger section) {
        return [DemoHeaderView class];
    };
    //tableView中cell通过滑动手势选中事件回调
    self.tableView.zx_selectedBlock = ^(NSIndexPath * _Nonnull selectedIndexPath, id  _Nonnull selectedModel) {
        weakSelf.title = [NSString stringWithFormat:@"已选中%ld个",weakSelf.tableView.zx_selectedArray.count];
    };
    //若点击了cell同样需要选中/取消选中效果，则需要实现以下代码
    //点击了tableView的cell
    self.tableView.zx_didSelectedAtIndexPath = ^(NSIndexPath * _Nonnull indexPath, DemoModel * _Nonnull model, id  _Nonnull cell) {
        model.selected = !model.selected;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        weakSelf.title = [NSString stringWithFormat:@"已选中%ld个",weakSelf.tableView.zx_selectedArray.count];
    };
}

#pragma mark 设置数据
- (void)setDatas{
    NSMutableArray *dataArr = [NSMutableArray array];
    for(int i = 0; i < 6;i++){
        NSMutableArray *sectionArr = [NSMutableArray array];
        for(int j = 0; j < 10;j++){
            DemoModel *demoModel = [[DemoModel alloc]init];
            demoModel.msg = [NSString stringWithFormat:@"第%d行",j];
            demoModel.selected = NO;
            [sectionArr addObject:demoModel];
        }
        [dataArr addObject:sectionArr];
        
    }
    self.tableView.zxDatas = dataArr;
}

#pragma mark 设置rightBarButtonItem
- (void)setSetButtonWithTitle:(NSString *)title{
    UIButton *setButton = [[UIButton alloc]init];
    [setButton setTitle:title forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
    [setButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *setButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem = setButtonItem;
}

#pragma mark - Actions
#pragma mark 点击了全选/取消全选
- (void)setAction:(UIButton *)sender{
    if([sender.currentTitle isEqualToString:@"全选"]){
        //全选
        [self.tableView zx_selectAll];
        [self setSetButtonWithTitle:@"取消全选"];
    }else{
        //取消全选
        [self.tableView zx_unSelectAll];
        [self setSetButtonWithTitle:@"全选"];
    }
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
