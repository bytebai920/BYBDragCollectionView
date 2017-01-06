//
//  CellDataModelManager.h
//  BYBDragCollectionView
//
//  Created by 白永炳 on 17/1/5.
//  Copyright © 2017年 BYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellDataModelManager : NSObject

+ (instancetype)sharedInstance;

+ (NSArray *)getDataFromServer;

@end
