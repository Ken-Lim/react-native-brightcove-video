//
//  RCTVideoPlayerViewController.h
//  RCTVideo
//
//  Created by Stanisław Chmiela on 31.03.2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "RCTBrightcoveVideo.h"
#import "RCTVideoPlayerViewControllerDelegate.h"

@interface RCTVideoPlayerViewController : AVPlayerViewController
@property (nonatomic, weak) id<RCTVideoPlayerViewControllerDelegate> rctDelegate;
@end
