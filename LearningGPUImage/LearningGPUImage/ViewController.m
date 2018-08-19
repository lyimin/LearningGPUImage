//
//  ViewController.m
//  LearningGPUImage
//
//  Created by eamon on 2018/8/16.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *titles;
@property(nonatomic, strong) NSMutableArray *classNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[].mutableCopy;
    _classNames = @[].mutableCopy;
    
    [self initDataSource];
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initDataSource {
    
    [self addCell:@"1.静态图片处理" class:@"StaticPictureController"];
}

- (void)addCell:(NSString *) title class:(NSString *) name {
    [self.titles addObject:title];
    [self.classNames addObject:name];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate | UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:true];
    }
}


#pragma mark - Getter | Setter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

@end
