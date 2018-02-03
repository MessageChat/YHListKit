//
//  ViewController.m
//  Example
//
//  Created by ShannonChen on 2018/1/8.
//  Copyright © 2018年 ShannonChen. All rights reserved.
//

#import "ViewController.h"
#import "YHCollectionViewAdapter.h"
#import "SCCutomCollectionViewCell.h"
#import "SCCollectionSectionHeaderView.h"
#import "SCCollectionSectionFooterView.h"

@interface ViewController () <UICollectionViewDelegate, YHCollectionViewAdapterDelegate>

@property (nonatomic, strong) YHCollectionViewAdapter *adapter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"YHListKit";
    
    self.adapter = [[YHCollectionViewAdapter alloc] init];
    self.adapter.collectionView = self.collectionView;
    self.adapter.collectionViewDelegate = self;
    self.adapter.delegate = self;
    
    [self reloadData];
    
}

- (BOOL)pullToRefreshEnabled {
    return YES;
}

- (void)viewDidTriggerRefresh {
    [self reloadData];
}


- (void)reloadData {
    // 更新数据
    NSMutableArray *sections = [NSMutableArray array];
    for (int section = 0; section < 4; section++) {
        
        BOOL hasMultiColumns = section % 2;
        
        YHCollectionViewSectionModel *sectionModel = [[YHCollectionViewSectionModel alloc] init];
        
        NSMutableArray *rows = [NSMutableArray array];
        for (int row = 0; row < 10; row++) {
            
            YHCollectionViewCellModel *cellModel = [[YHCollectionViewCellModel alloc] init];
            cellModel.dataModel = [NSString stringWithFormat:@"%i - %i", section, row];
            
            cellModel.cellClass = [SCCutomCollectionViewCell class];
            
            if (hasMultiColumns) {
                cellModel.cellWidth = 160;
                cellModel.cellHeight = 160;
            } else {
                cellModel.cellHeight = 70;
            }
            
            [rows addObject:cellModel];
        }
        
        sectionModel.cellModels = rows;
        sectionModel.headerClass = [SCCollectionSectionHeaderView class];
        sectionModel.headerHeight = 50;
        sectionModel.footerClass = [SCCollectionSectionFooterView class];
        sectionModel.footerHeight = 20;
        if (hasMultiColumns) {
            sectionModel.sectionInsets = UIEdgeInsetsMake(10, 20, 10, 20);
            sectionModel.minimumLineSpacing = 15;
        }
        [sections addObject:sectionModel];
    }
    self.adapter.sectionModels = sections;
    
    
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endHeaderRefreshing];
    });
}

#pragma mark - <UICollectionViewDelegate>
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __FUNCTION__);
}
    
#pragma mark - <YHCollectionViewAdapterDelegate>
- (void)collectionViewAdapter:(YHCollectionViewAdapter *)adapter didDequeueCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
}

@end
