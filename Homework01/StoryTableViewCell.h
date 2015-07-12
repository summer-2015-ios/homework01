//
//  StoryTableViewCell.h
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *pubDateView;
@property (weak, nonatomic) IBOutlet UILabel *miniTeaserView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end
