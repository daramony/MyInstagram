//
//  BodyTableViewCell.m
//  Intagram2
//
//  Created by Daramony on 3/27/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import "BodyTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface BodyTableViewCell ()

@property (strong, nonatomic) InstaEntity *entity;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation BodyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupPlayer:(InstaEntity *) entity {
    self.entity = entity;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglePlayVideoWithView:andIndex:)];
    [self addGestureRecognizer:self.tapGesture];

//    if (!self.player) {
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.entity.videoURL]];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bodyImageView.bounds;
        [self.bodyImageView.layer addSublayer:self.playerLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
//    }
    
    [self.player play];
    self.isPlaying = true;
}

-(void)playerDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [self.player play];
}

-(void)togglePlayVideoWithView:(UIView *)view andIndex:(NSInteger)index {
    if (self.isPlaying) {
        [self.player pause];
        self.isPlaying = false;
    }else {
        [self.player play];
        self.isPlaying = true;
    }
}

-(void)clearPlayer {
    if (self.tapGesture) {
        [self.bodyImageView removeGestureRecognizer:self.tapGesture];
        self.tapGesture = nil;
    }
    if (self.playerLayer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
        [self.player pause];
//        [self.bodyImageView.layer removeFromSuperlayer];
        [self.playerLayer removeFromSuperlayer];
        self.player = nil;
        self.playerLayer = nil;
        
    }
}

@end
