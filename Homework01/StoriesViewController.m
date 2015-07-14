//
//  StoriesViewController.m
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "StoriesViewController.h"
#import "StoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StoryViewController.h"

@interface StoriesViewController ()  <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* stories;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation StoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchStories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - UITableViewDataSource implementation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stories.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"storiesCell"];
    if(!cell){
        
    }
    cell.titleView.text = [self.stories[indexPath.row] valueForKeyPath:@"title.$text"];
    NSString* url = [self.stories[indexPath.row] valueForKeyPath:@"thumbnail.medium.$text"];
    [cell.imageView sd_setImageWithURL: [NSURL URLWithString:url ]
                      placeholderImage:[UIImage imageNamed:@"No_Image_Available"]];
    cell.miniTeaserView.text = [self.stories[indexPath.row] valueForKeyPath:@"teaser.$text"];
    cell.pubDateView.text = [self.stories[indexPath.row] valueForKeyPath:@"pubDate.$text"];
    return cell;
}

# pragma mark - fetch stories
-(void) fetchStories{
    [self.activityIndicator startAnimating];
    NSString* url = [NSString stringWithFormat:@"%@%ld", @"http://api.npr.org/query?fields=all&dateType=story&numResults=25&output=JSON&apiKey=MDE4MzQ4NjIzMDE0MjQ1ODc3MjAwMDg2Zg001&id=", self.itemId];
    NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if(error){
                        NSLog(@"error : %@", error);
                        return ;
                    }
                    NSMutableDictionary* dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:(NSJSONReadingMutableContainers)
                                                                                  error:&error];
                    if(error){
                        NSLog(@"Error while parsing json");
                        return;
                    }
                    self.stories = [dict valueForKeyPath:@"list.story"];
                    //NSLog(@"count of stories :%lu, %@", (unsigned long)self.stories.count, self.stories[0]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [(UITableView*)[self.view viewWithTag:1000] reloadData];
                        [self.activityIndicator stopAnimating];
                    });
                    
                }]
     resume];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    StoryViewController* vc = [segue destinationViewController];
    UITableViewCell* cell = (UITableViewCell*) sender;
    long row = [(UITableView*)[self.view viewWithTag:1000] indexPathForCell:cell].row;
    vc.storyTitle = [self.stories[row] valueForKeyPath:@"title.$text"];
    NSArray* reporterArray = [self.stories[row] valueForKeyPath:@"byline"];
    if([reporterArray count] > 0){
        vc.reporterName = [reporterArray[0] valueForKeyPath:@"name.$text"];
    } else{
        vc.reporterName = @"NA";
    }
    // get the link
    NSArray* links = [self.stories[row] valueForKeyPath:@"link"];
    if([links count ] > 0){
        for (NSDictionary* link in links) {
            if ([[link valueForKeyPath:@"type"] isEqualToString:@"html"]) {
                vc.browserLink = [link valueForKeyPath:@"$text"];
            }
        }
    } else{
        vc.browserLink = nil;
    }
    // duration and stream
    NSArray* audios = [self.stories[row] valueForKeyPath:@"audio"];
    if([audios count] > 0){
        vc.duration = [(NSString*)[audios[0] valueForKeyPath:@"duration.$text"] integerValue] ;
        NSArray* mp3s = [audios[0] valueForKeyPath:@"format.mp3"];
        if([mp3s count] > 0){
            vc.audio = [mp3s[0] valueForKeyPath:@"$text"];
        }
    }else{
        vc.duration = 0;
    }
    //teaser
    vc.teaser = [self.stories[row] valueForKeyPath:@"teaser.$text"];
    //aired date
     NSArray* shows = [self.stories[row] valueForKeyPath:@"show"];
    if([shows count] > 0){
        vc.dateAired = [shows[0] valueForKeyPath:@"showDate.$text"];
    }
}


@end
