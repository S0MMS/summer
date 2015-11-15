//
//  ViewController.m
//  Summer
//
//  Created by Chris Shreve on 11/14/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property NSMutableArray *data;

@end;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)buttonTapped:(id)sender {
    NSString *text = self.numberField.stringValue;
    
    NSArray *components = [text componentsSeparatedByString:@","];

    long x1sum = 0;
    long x2sum = 0;
    long x4sum = 0;
    self.data = [[NSMutableArray alloc] init];
    for (NSString *s in components) {
        NSInteger n = [s integerValue];
        x1sum += (n);
        x2sum += (n * n);
        x4sum += (n * n * n * n);
    }
    
    self.x1Sum.stringValue = [NSString stringWithFormat:@"%ld", x1sum];
    self.x2Sum.stringValue = [NSString stringWithFormat:@"%ld", x2sum];
    self.x4Sum.stringValue = [NSString stringWithFormat:@"%ld", x4sum];
    
    
    double ratio = x4sum/x2sum;
    self.ratio.stringValue = [NSString stringWithFormat:@"%lf", ratio];
    
    
    double x2SumModifier = x2sum/ratio;
    self.x2SumModifier.stringValue = [NSString stringWithFormat:@"%lf", x2SumModifier];
    
    NSLog(@"data = %@", components);
    
}





@end
