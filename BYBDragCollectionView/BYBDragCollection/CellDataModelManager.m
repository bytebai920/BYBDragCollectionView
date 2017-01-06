//
//  CellDataModelManager.m
//  BYBDragCollectionView
//
//  Created by 白永炳 on 17/1/5.
//  Copyright © 2017年 BYB. All rights reserved.
//

#import "CellDataModelManager.h"
#import "BYBCollectionViewCell.h"

@implementation CellDataModelManager

+ (instancetype)sharedInstance
{
    CellDataModelManager *manager = nil;
    @synchronized (self) {
        if (manager == nil) {
            manager = [[CellDataModelManager alloc] init];
        }
    }
    return manager;
}

+ (NSArray *)getDataFromServer
{
    NSArray *titleArr =  @[@"apple",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSArray *imageArr = @[@"apple.png",@"数字1.png", @"数字2.png",@"数字3.png",@"数字4.png", @"数字5.png",@"数字6.png",@"数字7.png", @"数字8.png",@"数字9.png"];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i++) {
        BYBCellModel *model = [[BYBCellModel alloc] init];
        model.titleName = titleArr[i];
        model.imgName = imageArr[i];
        [dataArr addObject:model];
    }
    
    return dataArr;
}

@end
