//
//  ViewController.h
//  Summer
//
//  Created by Chris Shreve on 11/14/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SumView.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *numberField;
@property (weak) IBOutlet NSButton *actionButton;
@property (weak) IBOutlet NSTextField *x4Sum;
@property (weak) IBOutlet NSTextField *x3Sum;
@property (weak) IBOutlet NSTextField *x2Sum;
@property (weak) IBOutlet NSTextField *x1Sum;
@property (weak) IBOutlet NSTextField *x1AbsSum;

@property (weak) IBOutlet NSTextField *ratio24;

@property (weak) IBOutlet NSTextField *ratio34;
@property (weak) IBOutlet NSTextField *ratio23;
@property (weak) IBOutlet NSTextField *ratio12;



@property (weak) IBOutlet NSStepper *stepper;
@property (weak) IBOutlet NSTextField *hLinesField;
@property (weak) IBOutlet NSTextField *vLinesField;

- (IBAction)buttonTapped:(id)sender;
- (IBAction)valueChanged:(id)sender;
- (IBAction)makeDataTapped:(id)sender;

@property (weak) IBOutlet NSTextField *permutationsField;
@property (weak) IBOutlet SumView *sumView;


@property (weak) IBOutlet NSButton *scaleYCheckbox;
- (IBAction)scaleYCheckboxTapped:(id)sender;

@property (weak) IBOutlet NSButton *gridCheckbox;
- (IBAction)gridCheckboxTapped:(id)sender;

@property (weak) IBOutlet NSButton *permutationsCheckbox;
- (IBAction)permutationsCheckboxTapped:(id)sender;

@property (weak) IBOutlet NSButton *sortedCheckbox;
- (IBAction)sortedCheckboxTapped:(id)sender;

@property (weak) IBOutlet NSButton *cdfCheckbox;
- (IBAction)cdfCheckboxTapped:(id)sender;

@property (weak) IBOutlet NSTextField *meanValue;
@property (weak) IBOutlet NSTextField *varianceValue;
@property (weak) IBOutlet NSTextField *stdDevValue;
@property (weak) IBOutlet NSTextField *stdDevPercentValue;
@property (weak) IBOutlet NSTextField *stdDev2PercentValue;


@end


