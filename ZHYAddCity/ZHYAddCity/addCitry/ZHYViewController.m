//
//  ViewController.m
//  ZHYAddCity
//
//  Created by 张昊煜 on 15/11/17.
//  Copyright © 2015年 ZhYu. All rights reserved.
//

#import "ZHYViewController.h"
#import "ZHYAddCityViewController.h"

@interface ZHYViewController ()<UITableViewDataSource, UITableViewDelegate, ZHYAddCityViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ZHYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addCity)];
    
    [self setupDate];
    
    [self setupUI];
}

- (void)addCity
{
    ZHYAddCityViewController *vc = [[ZHYAddCityViewController alloc] init];
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupDate
{
    [self.array addObject:[NSString stringWithFormat:@"宁波"]];
    [self.array addObject:[NSString stringWithFormat:@"北京"]];
    [self.array addObject:[NSString stringWithFormat:@"上海"]];
}

- (void)setupUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    //编辑模式
    [self.tableView setEditing:YES animated:YES];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    cell.detailTextLabel.text = [self.array objectAtIndex:indexPath.row];
    
    return cell;
}

//删除cell操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.array removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

//哪几行可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//哪几行可以移动(可移动的行数小于等于可编辑的行数)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//移动cell时的操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    if (sourceIndexPath != destinationIndexPath) {
        
        id object = [self.array objectAtIndex:sourceIndexPath.row];
        [self.array removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row > [self.array count]) {
            [self.array addObject:object];
        }
        else {
            [self.array insertObject:object atIndex:destinationIndexPath.row];
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

#pragma mark - ZHYAddCityViewControllerDelegate

- (void)ZHYAddCityViewControllerWitCity:(NSString *)city
{
    if ([self.array containsObject:city]) {
        NSLog(@"城市重复");
    } else {
        [self.array addObject:city];
        [self.tableView reloadData];
    }
    
}

#pragma mark - getters and setters 

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
