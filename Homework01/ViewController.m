//
//  ViewController.m
//  Homework01
//
//  Created by student on 7/12/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ViewController.h"
#import "ProgramsTopicsViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ProgramsTopicsViewController * vc = (ProgramsTopicsViewController*)[segue destinationViewController];
    if([[segue identifier] isEqualToString:@"topicsSegue" ]){
        vc.type = TOPICS;
    }else if ([[segue identifier] isEqualToString:@"programsSegue"]){
        vc.type = PROGRAMS;
    }

}

@end
