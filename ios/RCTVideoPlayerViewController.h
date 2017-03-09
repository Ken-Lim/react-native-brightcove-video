#import <AVKit/AVKit.h>
#import "RCTBrightcoveVideo.h"
#import "RCTVideoPlayerViewControllerDelegate.h"

@interface RCTVideoPlayerViewController : AVPlayerViewController
@property (nonatomic, weak) id<RCTVideoPlayerViewControllerDelegate> rctDelegate;
@end
