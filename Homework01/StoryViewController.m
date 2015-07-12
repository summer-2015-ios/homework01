//
//  StoryViewController.m
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *reporterNameView;
@property (weak, nonatomic) IBOutlet UILabel *dateAiredView;
@property (weak, nonatomic) IBOutlet UILabel *durationView;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.text = self.storyTitle;
    self.reporterNameView.text = self.reporterName;
    self.dateAiredView.text = self.dateAired;
    self.durationView.text = self.duration;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
