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

@property NSMutableArray *permutations;
@property NSMutableArray *adjustedPermutations;
@property NSMutableArray *data;

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
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)buttonTapped:(id)sender {
    [self calculatePermutations];
    [self calculateStuff];
    [self calculateStats];
    [self.stepper setIntegerValue:0];
    
    self.sumView.permutations = self.permutations;
    [self.sumView setNeedsDisplay:YES];
}

-(void) calculatePermutations {
    NSString *text = self.numberField.stringValue;
    NSArray *components = [text componentsSeparatedByString:@","];
        
    // init permutations
    self.permutations =  [[NSMutableArray alloc] initWithArray:@[@"0"]];

    for (NSString *n in components) {
        NSMutableArray *tempPerms = [[NSMutableArray alloc] initWithArray:self.permutations];
        
        for (NSString *p in self.permutations) {
            NSInteger newPermutation = [p integerValue] + [n integerValue];
            NSString *newPermStr = [NSString stringWithFormat:@"%ld", newPermutation];
            [tempPerms addObject:newPermStr];
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
    for (NSString *s in self.adjustedPermutations) {
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
    NSString *text = self.numberField.stringValue;
    NSArray *components = [text componentsSeparatedByString:@","];
    double height = 0;
    for (NSString *n in components) {
        height += [n doubleValue];
    }
    
    NSLog(@"height = %f", height);
    double mean = height/2.0;
    
    self.meanValue.stringValue = [NSString stringWithFormat:@"%f", mean];
    
    // calculate variance
    long x2sum = 0;
    for (NSString *pStr in self.permutations) {
        double n = [pStr doubleValue];
        double diff = (mean - n);
        x2sum += (diff * diff);
    }
    
    double variance = x2sum/([self.permutations count]);
    self.varianceValue.stringValue = [NSString stringWithFormat:@"%f", variance];
    
    
    // calculate std dev
    double stdDev = sqrt(variance);
    self.stdDevValue.stringValue = [NSString stringWithFormat:@"%f", stdDev];
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
