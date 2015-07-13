//
//  StoryViewController.m
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "StoryViewController.h"
#import "WebViewViewController.h"
@import AVFoundation;

@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *reporterNameView;
@property (weak, nonatomic) IBOutlet UILabel *dateAiredView;
@property (weak, nonatomic) IBOutlet UILabel *durationView;
@property (weak, nonatomic) IBOutlet UILabel *teaserView;
@property (strong, nonatomic) NSString* audioPlayableUrl;
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = self.storyTitle;
    self.reporterNameView.text = self.reporterName;
    self.dateAiredView.text = self.dateAired;
    self.durationView.text = [NSString stringWithFormat:@"%ld", self.duration ];
    self.teaserView.text = self.teaser;
    [self fetchMp3Stream];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewViewController* vc = [segue destinationViewController];
    vc.url = self.browserLink;
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
                    
                }] resume];
}
- (IBAction)audioClicked:(UIButton *)sender {
   // NSLog(@"1url = %@\n 2 url= %@",self.audio, self.audioPlayableUrl);
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.audioPlayableUrl]];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:([NSURL URLWithString:self.audioPlayableUrl])
//                                                                   error:&error];
//    
    [self.player play];
    NSLog(@"Volume %f", self.player.volume);
}
- (IBAction)playerRewind:(UIButton *)sender {
   // self.player
}
- (IBAction)playerPlay:(UIButton *)sender {
}
- (IBAction)playerForward:(UIButton *)sender {
}
- (IBAction)stopPlay:(id)sender {
    if(self.player){
        [self.player pause];
    }
}
@end
