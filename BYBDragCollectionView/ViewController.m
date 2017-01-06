//
//  ViewController.m
//  BYBDragCollectionView
//
//  Created by 白永炳 on 17/1/4.
//  Copyright © 2017年 BYB. All rights reserved.
//

#import "ViewController.h"
#import "BYBCollectionViewCell.h"
#import "BYBDragCollectionView.h"
#import "CellDataModelManager.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define PerRowGridCount 3

#define GridWidth (ScreenWidth/PerRowGridCount-4)


@interface ViewController ()<BYBDragCollectionViewDelegate, BYBDragCollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) BYBDragCollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray <BYBCellModel *> *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self initUI];
    
}

- (void)initData
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.dataArr addObjectsFromArray:[CellDataModelManager getDataFromServer]];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight);
    flowLayout.minimumLineSpacing  = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGRect ViewFrame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    
    self.collectionView = [[BYBDragCollectionView alloc] initWithFrame:ViewFrame collectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BYBCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bybCellIdentifier"];
    self.collectionView.dragDelegate = self;
    self.collectionView.dragDataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark BYBDragCollectionDataSource&Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArr.count) {
        return _dataArr.count;
    }
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(GridWidth, GridWidth);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BYBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bybCellIdentifier" forIndexPath:indexPath];
    [cell BYBCustomCellWithModel:_dataArr[indexPath.row]];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (void)cellStartMoveInView:(BYBDragCollectionView *)collection
{

}

- (void)cellisMovingInView:(BYBDragCollectionView *)collection
{

}

-(void)cellEndMovingInView:(BYBDragCollectionView *)collection
{

}

- (void)CollectionView:(BYBDragCollectionView *)collectionView resortDataArr:(NSArray *)dataArr
{

}

- (NSArray *)DataSourceForCollectionView:(BYBDragCollectionView *)collectionView
{
    return _dataArr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
