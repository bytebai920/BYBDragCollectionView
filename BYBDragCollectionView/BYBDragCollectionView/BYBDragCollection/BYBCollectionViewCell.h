//
//  BYBCollectionViewCell.h
//  BYBDragCollectionView
//
//  Created by 白永炳 on 17/1/4.
//  Copyright © 2017年 BYB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYBCellModel;

@interface BYBCollectionViewCell : UICollectionViewCell

- (void)BYBCustomCellWithModel:(BYBCellModel *)model;

@end

@interface BYBCellModel : NSObject

@property(nonatomic, strong) NSString *titleName;
@property(nonatomic, strong) NSString *imgName;

@end
