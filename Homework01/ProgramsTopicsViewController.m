//
//  ProgramsTopicsViewController.m
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ProgramsTopicsViewController.h"
#import "ViewController.h"
#import "StoriesViewController.h"

@interface ProgramsTopicsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* items;
@end

@implementation ProgramsTopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"selction %d", self.type);
    [self fetchItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource implementation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"programsCell"];
    if(!cell){
        
    }
    cell.textLabel.text = [self.items[indexPath.row] valueForKeyPath:@"title.$text"];
    return cell;
}
-(void) fetchItems{
    NSString* url;
    if( self.type == TOPICS){
        url = [NSString stringWithFormat:@"%@", @"http://api.npr.org/list?id=3002&output=JSON"];
    }else if(self.type == PROGRAMS){
        url = [NSString stringWithFormat:@"%@", @"http://api.npr.org/list?id=3004&output=JSON"];
    }
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
                    self.items = [dict valueForKey:@"item"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [(UITableView*)[self.view viewWithTag:1000] reloadData];
                    });
                    
                }]
     resume];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    StoriesViewController* vc = [segue destinationViewController];
    UITableViewCell* cell = (UITableViewCell*) sender;
    long row = [(UITableView*)[self.view viewWithTag:1000] indexPathForCell:cell].row;
    vc.itemId = [(NSString*)[self.items[row] valueForKey:@"id"] integerValue];
    NSLog(@"Sending id %ld", vc.itemId);
}


@end
