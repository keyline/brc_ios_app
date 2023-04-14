//
//  CustomImageFlowLayout.m
//  Mtrac
//
//  Created by Chakraborty, Sayan on 07/11/16.
//  Copyright © 2016 Chakraborty, Sayan. All rights reserved.
//
#import "CustomImageFlowLayout.h"

@implementation CustomImageFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 1.0;//0.0;
        self.minimumInteritemSpacing = 1.0;//0.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (CGSize)itemSize
{
    NSInteger numberOfColumns = 2;
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
    
    return CGSizeMake(itemWidth, itemWidth);
}

@end
