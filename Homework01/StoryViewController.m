//
//  StoryViewController.m
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "StoryViewController.h"
#import "WebViewViewController.h"
@import AVKit;
@import AVFoundation;

@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *reporterNameView;
@property (weak, nonatomic) IBOutlet UILabel *dateAiredView;
@property (weak, nonatomic) IBOutlet UILabel *durationView;
@property (weak, nonatomic) IBOutlet UILabel *teaserView;
@property (strong, nonatomic) NSString* audioPlayableUrl;
@property (strong, nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rewindBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBtn;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disablePlayerControls];
    self.titleView.text = self.storyTitle;
    self.reporterNameView.text = self.reporterName;
    self.dateAiredView.text = self.dateAired;
    self.durationView.text = [NSString stringWithFormat:@"%ld", self.duration ];
    self.teaserView.text = self.teaser;
    if (!self.audio) {
        self.audioBtn.enabled = NO;
    }else{
        [self fetchMp3Stream];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"browserSegue"]){
        WebViewViewController* vc = [segue destinationViewController];
        vc.url = self.browserLink;
    }
//    else if([[segue identifier] isEqualToString:@"playerSegue"]){
//        AVPlayerViewController *vc = [segue destinationViewController];
//        vc.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.audioPlayableUrl]];
//       // vc.
//    }
}
-(IBAction)backFromPlayerView:(UIStoryboardSegue* )segue{
    NSLog(@"Back from player view");
}
-(IBAction)backFromWebView:(UIStoryboardSegue* )segue{
    NSLog(@"Back from web view");
}

-(void) fetchMp3Stream{
    if(!self.audio){
        NSLog(@"no audio");
        return;
    }
    NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.audio]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if(error){
                        NSLog(@"error : %@", error);
                        return ;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.audioPlayableUrl = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"back from url : %@", self.audioPlayableUrl);
                    });
                    
                }]
     resume];
}
- (IBAction)audioClicked:(UIButton *)sender {
   // NSLog(@"1url = %@\n 2 url= %@",self.audio, self.audioPlayableUrl);
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.audioPlayableUrl]];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:([NSURL URLWithString:self.audioPlayableUrl])
//                                                                   error:&error];
//
    [self enablePlayerControls];
    [self.player play];
    NSLog(@"Volume %f", self.player.volume);
}
- (IBAction)play:(UIBarButtonItem *)sender {
    [self.player play];
}
- (IBAction)pause:(UIBarButtonItem *)sender {
    [self.player pause];
}
- (IBAction)forward:(UIBarButtonItem *)sender {
    [self.player seekToTime: CMTimeMakeWithSeconds(CMTimeGetSeconds(self.player.currentTime) + 5, self.player.currentTime.timescale)];
}
- (IBAction)rewind:(UIBarButtonItem *)sender {
     [self.player seekToTime: CMTimeMakeWithSeconds(CMTimeGetSeconds(self.player.currentTime) - 5, self.player.currentTime.timescale)];
}

-(void) enablePlayerControls{
    BOOL state = YES;
    self.rewindBtn.enabled = state;
    self.playBtn.enabled = state;
    self.pauseBtn.enabled = state;
    self.forwardBtn.enabled = state;
}
-(void) disablePlayerControls{
    BOOL state = NO;
    self.rewindBtn.enabled = state;
    self.playBtn.enabled = state;
    self.pauseBtn.enabled = state;
    self.forwardBtn.enabled = state;
}
@end
