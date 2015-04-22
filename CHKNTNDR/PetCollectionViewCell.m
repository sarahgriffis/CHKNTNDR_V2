//
//  PetCollectionViewCell.m
//  CHKNTNDR
//
//  Created by Sarah Griffis on 4/21/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import "PetCollectionViewCell.h"

@implementation PetCollectionViewCell
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont boldSystemFontOfSize:35.0];
        self.label.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.label];;
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

-(void)updateCell {
    //NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    //NSString *filename = [NSString stringWithFormat:@"%@/%@", sourcePath, self.imageName];
    
    //UIImage *image = [UIImage imageWithContentsOfFile:filename];
    
    //[self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //[self.imageView setImage:image];
}
@end
