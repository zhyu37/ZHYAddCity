//
//  ZHYAddCityViewController.m
//  ZHYAddCity
//
//  Created by 张昊煜 on 15/11/17.
//  Copyright © 2015年 ZhYu. All rights reserved.
//

#import "ZHYAddCityViewController.h"
#import "ZHYViewController.h"

@interface ZHYAddCityViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *cities;
@property (nonatomic, strong) NSMutableArray *filterCity;
@property (nonatomic, strong) UISearchController *searchC;

@end

@implementation ZHYAddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupDate];
    [self setupSeach];
    [self setupUI];
}

- (void)setupDate
{
    //城市 数据源
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [[NSDictionary alloc]
                   initWithContentsOfFile:path];
    self.array = [[self.cities allKeys] sortedArrayUsingSelector:
                 @selector(compare:)];
}

- (void)setupSeach
{
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchC.searchResultsUpdater = self;
    
    self.searchC.dimsBackgroundDuringPresentation = NO;
    
    self.searchC.hidesNavigationBarDuringPresentation = NO;
    
    self.searchC.searchBar.frame = CGRectMake(self.searchC.searchBar.frame.origin.x, self.searchC.searchBar.frame.origin.y, self.searchC.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchC.searchBar;
    
    self.searchC.searchBar.delegate = self;
    
    self.searchC.delegate = self;
}

- (void)setupUI
{
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    
    [self.view addSubview:self.tableView];
}

- (void)leftBtnClick
{
    self.searchC.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchC.active) {
        return 1;
    } else {
        return self.array.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchC.active) {
        return self.filterCity.count;
    } else {
        NSArray *a = [[NSArray alloc] initWithArray:[self.cities objectForKey:[self.array objectAtIndex:section]]];
        return a.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.searchC.active) {
        NSString *reuseIdentifier = @"filterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        }
        cell.textLabel.text = self.filterCity[indexPath.row];
        return cell;
    } else {
        NSString *reuseIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        }
        
        NSArray *a = [[NSArray alloc] initWithArray:[self.cities objectForKey:[self.array objectAtIndex:indexPath.section]]];
        cell.detailTextLabel.text = a[indexPath.row];
        return cell;
    }
    
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchC.active) {
        return nil;
    } else {
        return self.array;
    }
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchC.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    if (self.filterCity!= nil) {
        [self.filterCity removeAllObjects];
    }
    
    NSMutableArray *b = [NSMutableArray array];
    for (int i=0; i<self.array.count; i++) {
        NSArray *a = [[NSArray alloc] initWithArray:[self.cities objectForKey:[self.array objectAtIndex:i]]];
        [b addObjectsFromArray:a];
    }
    
    
    //过滤数据
    self.filterCity= [NSMutableArray arrayWithArray:[b filteredArrayUsingPredicate:preicate]];
    //刷新表格
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchC.active) {
        return nil;
    } else {
         return self.array[section];
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchC.active) {
        if ([self.delegate respondsToSelector:@selector(ZHYAddCityViewControllerWitCity:)]) {
            [self.delegate ZHYAddCityViewControllerWitCity:[self.filterCity objectAtIndex:indexPath.row]];
        }
    }else{
        NSArray *a = [[NSArray alloc] initWithArray:[self.cities objectForKey:[self.array objectAtIndex:indexPath.section]]];
        if ([self.delegate respondsToSelector:@selector(ZHYAddCityViewControllerWitCity:)]) {
            [self.delegate ZHYAddCityViewControllerWitCity:a[indexPath.row]];
        }
    }
    //判断 是否是 搜索状态
    self.searchC.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (NSArray *)array
{
    if (!_array) {
        _array = [[NSArray alloc] init];
    }
    return _array;
}

- (NSMutableArray *)filterCity
{
    if (!_filterCity) {
        _filterCity = [NSMutableArray array];
    }
    return _filterCity;
}

@end
