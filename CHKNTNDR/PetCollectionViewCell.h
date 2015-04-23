//
//  PetCollectionViewCell.h
//  CHKNTNDR
//
//  Created by Sarah Griffis on 4/21/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PetCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) UILabel* label;
@property UIImageView* imageView;

-(void)updateCell;
@end
