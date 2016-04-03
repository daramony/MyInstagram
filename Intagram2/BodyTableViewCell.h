//
//  BodyTableViewCell.h
//  Intagram2
//
//  Created by Daramony on 3/27/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaEntity.h"

@interface BodyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bodyImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

-(void)setupPlayer:(InstaEntity *) entity;
-(void)clearPlayer;

@end
