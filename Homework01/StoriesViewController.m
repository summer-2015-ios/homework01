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

@interface StoriesViewController ()  <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* stories;
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
    NSLog(@"title %@", [self.stories[indexPath.row] valueForKeyPath:@"title.$text"]);
    cell.titleView.text = [self.stories[indexPath.row] valueForKeyPath:@"title.$text"];
    NSString* url = [[self.stories[indexPath.row] valueForKey:@"image"][0] valueForKey:@"src"];
    [cell.imageView sd_setImageWithURL: [NSURL URLWithString:url ]
                      placeholderImage:[UIImage imageNamed:@"No_Image_Available"]];
    return cell;
}

# pragma mark - fetch stories
-(void) fetchStories{
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
                    });
                    
                }]
     resume];
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