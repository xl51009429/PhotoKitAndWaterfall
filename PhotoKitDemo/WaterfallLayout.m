//
//  WaterfallLayout.m
//  PhotoKitDemo
//
//  Created by 解梁 on 16/7/14.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "WaterfallLayout.h"

@interface WaterfallLayout ()

@property (nonatomic, retain)NSMutableArray *columnHeights;
@property (nonatomic, retain)NSMutableArray *attributes;

@end

@implementation WaterfallLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    float itemWidth = (kWidth - (kColumnNum + 1)*kColumnPadding)/kColumnNum;
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float itemHeight = itemWidth * [obj pixelHeight]/[obj pixelWidth];
        NSInteger index = [self shortestColumnIndex];
        UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        attribute.frame = CGRectMake(kColumnPadding + index * (itemWidth + kColumnPadding), [self.columnHeights[index] floatValue] + kColumnPadding, itemWidth, itemHeight);
        [self addColumnHeight:itemHeight atIndex:index];
        [self.attributes addObject:attribute];
    }];
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.attributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize
{
    if (self.dataSource.count == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(kWidth, [self longestColumnHeight] + kColumnPadding);
}

#pragma mark - private 

//返回最短列
- (NSInteger)shortestColumnIndex
{
    __block NSInteger index = 0;
    __block float height = [self.columnHeights[index] floatValue];
    [self.columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (height > [obj floatValue]) {
            index = idx;
            height = [obj floatValue];
        }
    }];
    return index;
}

//返回最高列的高度,计算collectionViewContentSize
- (CGFloat)longestColumnHeight
{
    __block float height = [self.columnHeights[0] floatValue];
    [self.columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (height < [obj floatValue]) {
            height = [obj floatValue];
        }
    }];
    return height;
}

//index列添加一个item，列的高度增加
- (void)addColumnHeight:(float)height atIndex:(NSInteger)index
{
    [self.columnHeights replaceObjectAtIndex:index withObject:@([self.columnHeights[index] floatValue] + height + kColumnPadding)];
}

#pragma mark - getter

- (NSMutableArray *)columnHeights
{
    if (_columnHeights == nil) {
        _columnHeights = [[NSMutableArray alloc]initWithCapacity:kColumnNum];
        for (int i = 0; i < kColumnNum; i++) {
            [_columnHeights addObject:@0];
        }
    }
    return _columnHeights;
}

- (NSMutableArray *)attributes
{
    if (_attributes == nil) {
        _attributes = [[NSMutableArray alloc]init];
    }
    return _attributes;
}

@end
