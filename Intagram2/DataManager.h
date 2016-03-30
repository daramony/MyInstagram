//
//  DataManager.h
//  Intagram2
//
//  Created by Daramony on 3/26/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (id) shareInstance;

@property (strong, nonatomic) NSString *accessToken;


@end
