//
//  ViewController.m
//  Summer
//
//  Created by Chris Shreve on 11/14/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import "ViewController.h"


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
//    [self makeFirstResponder:self];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)buttonTapped:(id)sender {
    [self calculatePermutations];
    [self calculateStuff];
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
//    self.permutationsField.stringValue = [self.permutations componentsJoinedByString:@","];
}

-(void) calculateStuff {
//    NSString *text = self.permutationsField.stringValue;
//    
//    NSArray *components = [text componentsSeparatedByString:@","];
    
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



@end
