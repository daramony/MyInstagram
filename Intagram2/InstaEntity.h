//
//  InstaEntity.h
//  Intagram2
//
//  Created by Daramony on 3/27/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    InstaTypeImage,
    InstaTypeVideo,
} InstaType;

@interface InstaEntity : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *imageURL;
@property (assign, nonatomic) InstaType type;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;
@property (strong, nonatomic) NSString *videoURL;
@property (strong, nonatomic) NSString *status;

@end
