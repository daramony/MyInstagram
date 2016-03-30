//
//  InstaService.m
//  Intagram2
//
//  Created by Daramony on 3/27/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import "InstaService.h"
#import "DataManager.h"

#define INSTA_SELF @"https://api.instagram.com/v1/users/self/feed?access_token"

@interface InstaService ()

@property (strong, nonatomic) NSString *nextMaxId;
@property (assign, nonatomic) BOOL test;

@end

@implementation InstaService

- (NSString *)getURL:(NSString *)urlString
{
    NSString *string = [NSString stringWithFormat:@"%@=%@", urlString, [[DataManager shareInstance] accessToken]];
    if (self.nextMaxId) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@", self.nextMaxId]];
    }
    return string;
}

- (void)clearNextMaxId {
    self.nextMaxId = nil;
}

#define NEXT_MAX_ID @"pagination.next_max_id"
#define INSTA_USERNAME @"user.username"
#define INSTA_FULLNAME @"user.full_name"
#define INSTA_PROFILE_IMAGE_URL @"user.profile_picture"
#define INSTA_IMAGE_URL @"images.standard_resolution.url"
#define INSTA_IMAGE_WIDTH @"images.standard_resolution.width"
#define INSTA_IMAGE_HEIGHT @"images.standard_resolution.height"
#define INSTA_TYPE @"type"

- (void)getMyFeedWithCompletionHandler:(void(^)(NSMutableArray *list))complete {
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:[self getURL:INSTA_SELF]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *error = nil;
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            self.nextMaxId = [dataDict valueForKeyPath:NEXT_MAX_ID];
            
            NSArray *dataList = [dataDict objectForKey:@"data"];
            
            for (NSDictionary *data in dataList) {
                InstaEntity *entity = [[InstaEntity alloc] init];
                entity.username = [data valueForKeyPath:INSTA_USERNAME];
                entity.fullname = [data valueForKeyPath:INSTA_FULLNAME];
                if (entity.fullname.length == 0) entity.fullname = entity.username;
                entity.profileImageURL = [data valueForKeyPath:INSTA_PROFILE_IMAGE_URL];
                entity.imageURL = [data valueForKeyPath:INSTA_IMAGE_URL];
                entity.type = [[data valueForKeyPath:INSTA_TYPE] isEqualToString:@"image"] ? InstaTypeImage : InstaTypeVideo;
                entity.width = [[data valueForKeyPath:INSTA_IMAGE_WIDTH] integerValue];
                entity.height = [[data valueForKeyPath:INSTA_IMAGE_HEIGHT] integerValue];
                [resultList addObject:entity];
            }
            
            if (complete) {
                complete(resultList);
            }
        }
    }];
    [dataTask resume];
}

@end
