//
//  FeedTableViewController.m
//  Intagram2
//
//  Created by Daramony on 3/26/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import "FeedTableViewController.h"
#import "HeadTableViewCell.h"
#import "BodyTableViewCell.h"
#import "InstaService.h"
#import "UIImageView+AsyncLoad.h"

@interface FeedTableViewController ()

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) InstaService *instaService;

@end

@implementation FeedTableViewController

-(NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

-(InstaService *)instaService {
    if (!_instaService) {
        _instaService = [[InstaService alloc] init];
    }
    return _instaService;
}

-(void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getMyFeedWithCompletionHandler:nil];
    [self loadComponent];
}

-(void)getMyFeedWithCompletionHandler:(void(^)(BOOL success))complete {
    [self.instaService getMyFeedWithCompletionHandler:^(NSMutableArray *list) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.dataList = list;
            [self.tableView reloadData];
            if (complete) complete(YES);
        });
    }];
}

-(void)loadComponent {
    self.navigationItem.title = @"MyInsta";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(refreshChange:) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:refreshControl];
}

-(void)refreshChange:(UIResponder *)sender {
    
    [self.instaService clearNextMaxId];
    [self getMyFeedWithCompletionHandler:^(BOOL success) {
        [self.refreshControl endRefreshing];
    }];
}

-(void)getMyFeedMore {
    [self.instaService getMyFeedWithCompletionHandler:^(NSMutableArray *list) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSMutableArray *indexPathList = [[NSMutableArray alloc] init];
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (InstaEntity *entity in list) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:0  inSection:[self.dataList count]];
                [indexPathList addObject:path];
                [indexSet addIndex:[self.dataList count]];
                [self.dataList addObject:entity];
            }
            
            [self.tableView beginUpdates];
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:indexPathList withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
        });
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataList count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth([UIScreen mainScreen].bounds) + 37;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    InstaEntity *entity = self.dataList[section];
    static NSString *cellIdentifier = @"cellHead";
    HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell.headImageView asyncLoadWithURLString:entity.profileImageURL];
    [cell.headImageView makeCornerRadius];
    cell.headLabel.text = entity.fullname;
    
    UIView *view = [[UIView alloc] initWithFrame:[cell frame]];
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [view addSubview:cell];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitfier = @"cellBody";
    BodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitfier];
    if (!cell) {
        cell = [[BodyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentitfier];
    }
    
    InstaEntity *entity = self.dataList[indexPath.section];

    [cell.bodyImageView asyncLoadWithURLString:entity.imageURL];
 
    if (indexPath.section == self.dataList.count-2) {
        [self getMyFeedMore];
    }
    
    return cell;
}

@end
