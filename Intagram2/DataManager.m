//
//  DataManager.m
//  Intagram2
//
//  Created by Daramony on 3/26/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (id) shareInstance
{
    static DataManager *dataManager = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
