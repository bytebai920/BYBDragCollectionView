//
//  BYBDragCollectionView.m
//  BYBDragCollectionView
//
//  Created by 白永炳 on 17/1/4.
//  Copyright © 2017年 BYB. All rights reserved.
//

#import "BYBDragCollectionView.h"


@interface BYBDragCollectionView ()

/**
 手指位置
 */
@property(nonatomic, assign) CGPoint fingerLocation;

/**
 被选中的cell的新位置
 */
@property(nonatomic, strong) NSIndexPath *relocatedIndexPath;

/**
 选中cell的原始位置
 */
@property(nonatomic, strong) NSIndexPath *originalIndexPath;

/**
 选中的截图
 */
@property(nonatomic, strong) UIView *snapshot;

@end

@implementation BYBDragCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self addGestureRecognizer:longpress];
        
    }
    
    return self;
}

#pragma mark Gesture LongPress

- (void)longPressGestureRecognized:(UIGestureRecognizer *)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState gestureState = longPress.state;
    
    _fingerLocation  = [longPress locationInView:self];
    _relocatedIndexPath  = [self indexPathForItemAtPoint:_fingerLocation];
    
    switch (gestureState) {
        case UIGestureRecognizerStateBegan: // 开始长按
        {
            // start long press indexpath
            _originalIndexPath = [self indexPathForItemAtPoint:_fingerLocation];
            if (_originalIndexPath) {
                // start cell shotview & remove pressing cell
                [self cellSelectedAtIndexPath:_originalIndexPath];
                if (self.dragDelegate && [self.dragDelegate respondsToSelector:@selector(cellStartMoveInView:)]) {
                    [self.dragDelegate cellStartMoveInView:self];
                }
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = _snapshot.center;
            center.x = _fingerLocation.x;
            center.y = _fingerLocation.y;
            
            _snapshot.center = center;
            
            if (self.dragDelegate && [self.dragDelegate respondsToSelector:@selector(cellisMovingInView:)]) {
                [self.dragDelegate cellisMovingInView:self];
            }
            
            _relocatedIndexPath = [self indexPathForItemAtPoint:center];
            if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
                [self upadateCellLocationWithIndexPath:_relocatedIndexPath];
                
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            
            [self didEndDragging];
            break;
        }
        default:
            break;
    }
}


#pragma mark start Move
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    
    UIView *snapshot = [self customSnapShotFromView:cell];
    
    snapshot.userInteractionEnabled = YES;
    [self addSubview:snapshot];
    self.snapshot = snapshot;
    
    cell.hidden = YES;
    CGPoint center = _snapshot.center;
    center.y = _fingerLocation.y;
    
    [UIView animateWithDuration:0.1 animations:^{
        _snapshot.transform = CGAffineTransformMakeScale(1.1, 1.1);
        _snapshot.alpha = 0.8;
        _snapshot.center = center;
    }];
    
}

- (UIView *)customSnapShotFromView:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.center = inputView.center;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.3;
    
    return snapshot;
    
}


#pragma mark isMoving
- (void)upadateCellLocationWithIndexPath:(NSIndexPath *)indexPath
{
    [self updateDataSource];
    [self moveItemAtIndexPath:_originalIndexPath toIndexPath:indexPath];
    _originalIndexPath = indexPath;
    
}

- (void)updateDataSource
{
    NSMutableArray *temArr = [NSMutableArray arrayWithCapacity:0];
    // delegate 获取当前排列顺序的数组
    if (self.dragDataSource && [self.dragDataSource respondsToSelector:@selector(DataSourceForCollectionView:)]) {
        [temArr addObjectsFromArray: [self.dragDataSource DataSourceForCollectionView:self]];
    }
    
    [self exchangeCellDataOrderWithArray:temArr FromIndex:_originalIndexPath.row ToIndex:_relocatedIndexPath.row];
    //
    if (self.dragDelegate && [self.dragDelegate respondsToSelector:@selector(CollectionView:resortDataArr:)]) {
        [self.dragDelegate CollectionView:self resortDataArr:temArr];
    }
}

- (void)exchangeCellDataOrderWithArray:(NSMutableArray *)array FromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex
{
   // 选中的对象移除，放置位置前的对象迁移，放在迁移的位置
    if (fromIndex < toIndex) {
        for (NSInteger index = fromIndex; index < toIndex; index ++) {
            [array exchangeObjectAtIndex:index withObjectAtIndex:index + 1];
        }
    }else
    {
        for (NSInteger index = fromIndex; index > toIndex; index --) {
            [array exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
        }
    }
}

#pragma mark endDragging

- (void)didEndDragging
{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath];
    cell.hidden = NO;
    cell.alpha = 1.0;
    [UIView animateWithDuration:0.1 animations:^{
        _snapshot.center = cell.center;
        _snapshot.alpha = 0.0;
        _snapshot.transform = CGAffineTransformIdentity;
        
        //cell.alpha = 1.0;
    }completion:^(BOOL finished) {
        cell.hidden = NO;
        
        [_snapshot removeFromSuperview];
        _snapshot = nil;
        _originalIndexPath = nil;
        _relocatedIndexPath = nil;
    }];
    
    if (self.dragDelegate && [self.dragDelegate respondsToSelector:@selector(cellEndMovingInView:)]) {
        [self.dragDelegate cellEndMovingInView:self];
    }

}

@end
