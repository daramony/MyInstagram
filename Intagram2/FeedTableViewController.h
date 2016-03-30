//
//  FeedTableViewController.h
//  Intagram2
//
//  Created by Daramony on 3/26/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
