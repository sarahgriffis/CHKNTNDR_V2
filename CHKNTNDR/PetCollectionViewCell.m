//
//  PetCollectionViewCell.m
//  CHKNTNDR
//
//  Created by Sarah Griffis on 4/21/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import "PetCollectionViewCell.h"
@import AVFoundation;


@implementation PetCollectionViewCell
//@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 75.0)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont boldSystemFontOfSize:35.0];
        self.label.backgroundColor = [UIColor whiteColor];
        self.label.layer.cornerRadius = 8;
        self.label.layer.masksToBounds = YES;
        [self.contentView addSubview:self.label];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.imageView];
        
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        

        self.contentView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.imageView setFrame:AVMakeRectWithAspectRatioInsideRect(self.imageView.image.size, self.contentView.bounds)];
    CGFloat ratio = [self ratioForImage:self.imageView.image];
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width * ratio, self.imageView.image.size.height * ratio);
    self.imageView.center = self.contentView.center;
    self.imageView.layer.cornerRadius = 8;
    self.imageView.layer.masksToBounds = YES;
    
    self.imageView.layer.borderWidth = 2.0;
    self.imageView.layer.borderColor = [UIColor redColor].CGColor;
    
    [self.imageView setNeedsDisplay];
//    [self.imageView set]

}

- (CGFloat)ratioForImage:(UIImage *)image
{
    CGFloat ratio = 1.0;
    if (image.size.width > image.size.height) {
        ratio = self.contentView.frame.size.width / image.size.width;
    } else {
        ratio = self.contentView.frame.size.height / image.size.height;
    }
    return ratio;
}

-(void)updateCell {
    //NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    //NSString *filename = [NSString stringWithFormat:@"%@/%@", sourcePath, self.imageName];
    
    //UIImage *image = [UIImage imageWithContentsOfFile:filename];
    
    //[self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //[self.imageView setImage:image];
}
@end
