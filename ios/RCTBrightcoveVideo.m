#import "RCTBrightcoveVideo.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>
#import <React/RCTConvert.h>

//@import BrightcovePlayerSDK
//@import BrightcoveIMA

#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>
#import <BrightcoveIMA/BrightcoveIMA.h>
//#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>

static NSString *const statusKeyPath = @"status";
static NSString *const playbackLikelyToKeepUpKeyPath = @"playbackLikelyToKeepUp";
static NSString *const playbackBufferEmptyKeyPath = @"playbackBufferEmpty";
static NSString *const readyForDisplayKeyPath = @"readyForDisplay";
static NSString *const playbackRate = @"rate";

NSString *const BCVideoId = @"videoId";
NSString *const BCAccountId = @"accountId";
NSString *const BCPolicyKey = @"policyKey";


@interface RCTBrightcoveVideo () <BCOVPlaybackControllerDelegate>
    @property (nonatomic, strong) BCOVPlaybackService *playbackService;
    @property (nonatomic) RCTEventDispatcher *eventDispatcher;
    @property (nonatomic) id<BCOVPlaybackController> playbackController;
    @property (nonatomic) BCOVPUIPlayerView *playerView;
@end

@implementation RCTBrightcoveVideo
    {
        NSDictionary *_video;
        BOOL _play;
        BOOL _autoPlay;
        BOOL _autoAdvance;
        BOOL isRequestingContent;
    }
    
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
    {
        if (self = [super init]) {
            self.eventDispatcher = eventDispatcher;
            BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
            
            id<BCOVPlaybackController> playbackController =
            [manager createPlaybackControllerWithViewStrategy:nil];
            playbackController.delegate = self;
            playbackController.autoAdvance = NO;
            self.playbackController.autoPlay = NO;
            
            self.playbackController = playbackController;
            [self.playbackController setAllowsExternalPlayback:YES];
            
            BCOVPUIBasicControlView *controlView = [BCOVPUIBasicControlView basicControlViewWithVODLayout];
            self.playerView = [[BCOVPUIPlayerView alloc] initWithPlaybackController:self.playbackController options:nil controlsView:controlView];
            self.playerView.frame = self.bounds;
            self.playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            [self addSubview:self.playerView];
            self.playerView.frame = self.bounds;
            
            self.playerView.playbackController = self.playbackController;
            
        }
        return self;
    }
- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerView.frame = self.bounds;
}
 
#pragma mark Brightcove Video Prop Methods
-(BOOL)play {
    return _play;
}
    
-(void)setPlay:(BOOL)play {
    _play = play;
    if (play == YES) {
        [self.playerView.playbackController play];
    } else {
        [self.playerView.playbackController pause];
    }
}
    
    
-(NSDictionary *)video {
    return _video;
}

-(void)setVideo:(NSDictionary *)video {
    _video = video;
    [self requestContentFromPlaybackService];
}

- (void)setAutoAdvance:(BOOL)autoAdvance {
    self.playbackController.autoAdvance = autoAdvance;
}
    
-(BOOL)autoAdvance {
    return _autoAdvance;
}
    
    
- (void)setAutoPlay:(BOOL)autoPlay {
    self.playbackController.autoPlay = autoPlay;
}
    
-(BOOL)autoPlay {
    return _autoPlay;
}

- (void)requestContentFromPlaybackService
{
    NSString *videoId = [_video objectForKey:BCVideoId];
    NSString *accountId = [_video objectForKey:BCAccountId];
    NSString *policyKey = [_video objectForKey:BCPolicyKey];
    RCTLog(@"%@ , %@, %@", videoId, accountId, policyKey);
    RCTLog(@"%@", _video);
    //  if (!_videoId || !_policyKey || !_accountId) {
    ////    RCTLogError(@"No videId provided %@", _videoId);
    //  } else {
    //    RCTLog(@"%@ , %@, %@", _videoId, _policyKey, _accountId);
    self.playbackService = [[BCOVPlaybackService alloc] initWithAccountId:accountId
                                                                policyKey:policyKey];
    [self.playbackService findVideoWithVideoID:videoId parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        
        if (video)
        {
            BCOVPlaylist *playlist = [[BCOVPlaylist alloc] initWithVideo:video];
            
            BCOVPlaylist *updatedPlaylist = [playlist update:^(id<BCOVMutablePlaylist> mutablePlaylist) {
                
                //          NSMutableArray *updatedVideos = [NSMutableArray arrayWithCapacity:mutablePlaylist.videos.count];
                
                //          for (BCOVVideo *video in mutablePlaylist.videos)
                //          {
                //            [updatedVideos addObject:[RCTBrightcovePlayer updateVideoWithVMAPTag:video]];
                //          }
                //
                //          mutablePlaylist.videos = updatedVideos;
                
            }];
            
            [self.playerView.playbackController setVideos:updatedPlaylist.videos];
        }
        else
        {
            RCTLogError(@"Error finding video from service: %@", error);
        }
        
    }];
    //  }
}
}

    @end
