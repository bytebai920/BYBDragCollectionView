//
//  BYBCollectionViewCell.m
//  BYBDragCollectionView
//
//  Created by 白永炳 on 17/1/4.
//  Copyright © 2017年 BYB. All rights reserved.
//

#import "BYBCollectionViewCell.h"

@interface BYBCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *cellName;

@end

@implementation BYBCollectionViewCell

- (void)BYBCustomCellWithModel:(BYBCellModel *)model
{
    self.iconImgView.image = [UIImage imageNamed:model.imgName];
    self.cellName.text = [NSString stringWithFormat:@"%@", model.titleName];
}

@end

@implementation BYBCellModel


@end
