//
//  UIImageView+AsyncLoad.h
//  Intagram2
//
//  Created by Daramony on 3/27/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncLoad)

- (void)asyncLoadWithURLString:(NSString *)urlString;
- (void)makeCornerRadius;

@end
