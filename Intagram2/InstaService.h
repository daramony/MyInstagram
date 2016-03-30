//
//  InstaService.h
//  Intagram2
//
//  Created by Daramony on 3/27/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstaEntity.h"

@interface InstaService : NSObject

- (void)clearNextMaxId;
- (void)getMyFeedWithCompletionHandler:(void(^)(NSMutableArray *list))complete;

@end
