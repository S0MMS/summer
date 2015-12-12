//
//  ViewController.m
//  Summer
//
//  Created by Chris Shreve on 11/14/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import "ViewController.h"
#import <math.h>


@interface ViewController ()

@property NSMutableArray *components;
@property NSMutableArray *permutations;
@property NSMutableArray *adjustedPermutations;
@property NSMutableArray *hLines;
@property NSMutableArray *vLines;
@property NSMutableArray *data;
@property double mean;
@property double stdDev;
@property double stdDevPercent;

@end;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self.view.window makeFirstResponder:self];
    
    self.gridCheckbox.state = YES;
    self.sumView.showGrid = self.gridCheckbox.state;
    
    self.permutationsCheckbox.state = YES;
    self.sumView.showPermutations = self.permutationsCheckbox.state;
    
    self.sortedCheckbox.state = YES;
    self.sumView.showSorted = self.sortedCheckbox.state;
    
    self.cdfCheckbox.state = YES;
    self.sumView.showCDF = self.cdfCheckbox.state;
    
    self.meanValue.stringValue = @"";    
    self.varianceValue.stringValue = @"";
    self.stdDevValue.stringValue = @"";
    self.stdDevPercentValue.stringValue = @"";
    
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask) handler:^(NSEvent *event){
//        [self keyWasPressedFunction: event];
        //Or just put your code here
        NSLog(@"key press %@", event);
    }];
    
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)buttonTapped:(id)sender {
    [self readComponents];
    [self readHLines];
    [self readVLines];
    
    [self calculatePermutations];
    [self calculateStuff];
    [self calculateStats];
    [self.stepper setIntegerValue:0];
    

    
    self.sumView.permutations = self.permutations;
    self.sumView.hLines = self.hLines;
    self.sumView.vLines = self.vLines;
    [self.sumView setNeedsDisplay:YES];
}

-(void) readComponents {
    self.components = [[NSMutableArray alloc] init];
    
    NSString *text = self.numberField.stringValue;
    NSArray *components = [text componentsSeparatedByString:@","];
    for (NSString *c in components) {
        NSNumber *n = [NSNumber numberWithInteger:[c integerValue]];
        [self.components addObject:n];
    }
}

-(void) readHLines {
    self.hLines = [[NSMutableArray alloc] init];
    
    NSString *text = self.hLinesField.stringValue;
    NSArray *components = [text componentsSeparatedByString:@","];
    for (NSString *c in components) {
        NSNumber *n = [NSNumber numberWithDouble:[c doubleValue]];
        [self.hLines addObject:n];
    }
}

-(void) readVLines {
    self.vLines = [[NSMutableArray alloc] init];
    
    NSString *text = self.vLinesField.stringValue;
    NSArray *components = [text componentsSeparatedByString:@","];
    for (NSString *c in components) {
        NSNumber *n = [NSNumber numberWithDouble:[c doubleValue]];
        [self.vLines addObject:n];
    }
}

-(void) calculatePermutations {

    self.permutations = [[NSMutableArray alloc] init];
    [self.permutations addObject:[NSNumber numberWithInt:0]];

    for (NSNumber *n in self.components) {
        NSMutableArray *tempPerms = [[NSMutableArray alloc] initWithArray:self.permutations];

        for (NSNumber *p in self.permutations) {
            NSNumber *newPermutation = [NSNumber numberWithInteger:([p integerValue] + [n integerValue])];;
            [tempPerms addObject:newPermutation];
        }
        
        
        self.permutations = tempPerms;
    }
    self.adjustedPermutations = self.permutations;
    self.permutationsField.stringValue = [self.adjustedPermutations componentsJoinedByString:@","];
}

-(void) calculateStuff {

    long x1sum = 0;
    long x2sum = 0;
    long x4sum = 0;
    self.data = [[NSMutableArray alloc] init];
    for (NSNumber *s in self.adjustedPermutations) {
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
    
//    NSLog(@"data = %@", components);
}

-(void) calculateStats {
    // calculate mean
    double height = 0;
    for (NSNumber *n in self.components) {
        height += [n doubleValue];
    }
    
    NSLog(@"height = %f", height);
    self.mean = height/2.0;
    
    self.meanValue.stringValue = [NSString stringWithFormat:@"%f", self.mean];
    
    // calculate variance
    double x2sum = 0;
    for (NSNumber *p in self.permutations) {
        double n = [p doubleValue];
        double diff = (self.mean - n);
        x2sum = x2sum + pow(diff, 2);
    }
    
    double variance = x2sum/([self.permutations count]);
    self.varianceValue.stringValue = [NSString stringWithFormat:@"%f", variance];
    
    
    // calculate std dev
    self.stdDev = sqrt(variance);
    self.stdDevValue.stringValue = [NSString stringWithFormat:@"%f", self.stdDev];
    
    // calculate percent of values between u - o and u + o
    int count = 0;
    for (NSNumber *p in self.permutations) {
        double n = [p doubleValue];
        if ( ((self.mean - self.stdDev) <= n) && (n <= (self.mean + self.stdDev)) ) {
            count++;
        }
    }
    NSLog(@"count within u - o and u + o = %d", count);
    self.stdDevPercent = (double)count/(double)[self.permutations count];
    NSLog(@"%f", self.stdDevPercent);
    self.stdDevPercentValue.stringValue = [NSString stringWithFormat:@"%f", self.stdDevPercent];
}


- (IBAction)valueChanged:(id)sender {
    NSStepper *stepper = (NSStepper *)sender;
    NSInteger v = [stepper integerValue];

    self.adjustedPermutations = [[NSMutableArray alloc] init];
    
    for (NSString *p in self.permutations) {
        NSInteger adjustedValue = [p integerValue] + v;
        
        NSString *abs = [NSString stringWithFormat:@"%ld", labs(adjustedValue)];
        [self.adjustedPermutations addObject:abs];
    }
    NSLog(@"adjusted perm = %@", self.adjustedPermutations);
    
    self.permutationsField.stringValue = [self.adjustedPermutations componentsJoinedByString:@","];
    
    [self calculateStuff];
}



-(void)keyDown:(NSEvent*)event {
    NSLog(@"key = %@", event);
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (IBAction)gridCheckboxTapped:(id)sender {
    self.sumView.showGrid = self.gridCheckbox.state;
    [self.sumView setNeedsDisplay:YES];
}

- (IBAction)permutationsCheckboxTapped:(id)sender {
    self.sumView.showPermutations = self.permutationsCheckbox.state;
    [self.sumView setNeedsDisplay:YES];
}

- (IBAction)sortedCheckboxTapped:(id)sender {
    self.sumView.showSorted = self.sortedCheckbox.state;
    [self.sumView setNeedsDisplay:YES];
}


double cumulativeNormal(double x) {
    return 0.5 * erfc(-x * M_SQRT1_2);
}

double cumulativeNormalWithMeanAndVariance(double x, double mean, double variance) {
    return 0.5 * erfc(((mean - x)/sqrt(variance)) * M_SQRT1_2);
}

double cdf(double x, double mean, double stdDev) {
    return (1/2)*(1 + erfc( (x - mean)/(stdDev * M_SQRT2) ));
}


- (IBAction)cdfCheckboxTapped:(id)sender {
    self.sumView.showCDF = self.cdfCheckbox.state;
    [self.sumView setNeedsDisplay:YES];
}

@end
