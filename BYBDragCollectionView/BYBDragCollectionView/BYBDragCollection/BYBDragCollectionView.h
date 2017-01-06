//
//  BYBDragCollectionView.h
//  BYBDragCollectionView
//
//  Created by 白永炳 on 17/1/4.
//  Copyright © 2017年 BYB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYBDragCollectionViewDelegate;
@protocol BYBDragCollectionViewDataSource;

@interface BYBDragCollectionView : UICollectionView

@property(nonatomic, assign) id<BYBDragCollectionViewDelegate>dragDelegate;
@property(nonatomic, assign) id<BYBDragCollectionViewDataSource>dragDataSource;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout;

@end

@protocol BYBDragCollectionViewDataSource <UICollectionViewDataSource>

- (NSArray *)DataSourceForCollectionView:(BYBDragCollectionView *)collectionView;

@end

@protocol BYBDragCollectionViewDelegate <UICollectionViewDelegate>

@optional
- (void)cellStartMoveInView:(BYBDragCollectionView *)collection;
- (void)cellisMovingInView:(BYBDragCollectionView *)collection;
- (void)cellEndMovingInView:(BYBDragCollectionView *)collection;

@required
- (void)CollectionView:(BYBDragCollectionView *)collectionView resortDataArr:(NSArray *)dataArr;

@end
