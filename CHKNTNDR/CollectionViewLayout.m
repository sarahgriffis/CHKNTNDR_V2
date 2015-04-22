//
//  CollectionViewLayout.m
//  CHKNTNDR
//
//  Created by Sarah Griffis on 4/21/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout
-(id)init {
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(250, 250);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(100, 0.0, 100, 0.0);
        self.minimumLineSpacing = 50.0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        //if (ABS(itemHorizontalCenter - horizontalCenter) &lt; ABS(offsetAdjustment)) {
        //    offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        //}
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}


@end
