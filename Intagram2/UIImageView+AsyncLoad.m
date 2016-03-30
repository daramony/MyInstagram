//
//  UIImageView+AsyncLoad.m
//  Intagram2
//
//  Created by Daramony on 3/27/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import "UIImageView+AsyncLoad.h"

@implementation UIImageView (AsyncLoad)

-(void)asyncLoadWithURLString:(NSString *)urlString {
    self.image = nil;
    self.image = [UIImage imageNamed:@"gray"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURL *url = [NSURL URLWithString:urlString];
                       NSData *data = [NSData dataWithContentsOfURL:url];
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           UIImage *image = [UIImage imageWithData:data];
                           [self setImage:image];
                       });
                   });
}

-(void)makeCornerRadius {
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor grayColor].CGColor;
}

@end
