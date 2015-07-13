//
//  StoryViewController.m
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "StoryViewController.h"
#import "WebViewViewController.h"

@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *reporterNameView;
@property (weak, nonatomic) IBOutlet UILabel *dateAiredView;
@property (weak, nonatomic) IBOutlet UILabel *durationView;
@property (weak, nonatomic) IBOutlet UILabel *teaserView;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = self.storyTitle;
    self.reporterNameView.text = self.reporterName;
    self.dateAiredView.text = self.dateAired;
    self.durationView.text = [NSString stringWithFormat:@"%ld", self.duration ];
    self.teaserView.text = self.teaser;
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
@end
