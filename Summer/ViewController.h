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
@property (weak) IBOutlet NSTextField *x2Sum;
@property (weak) IBOutlet NSTextField *x4Sum;
@property (weak) IBOutlet NSTextField *x1Sum;
@property (weak) IBOutlet NSTextField *ratio;
@property (weak) IBOutlet NSTextField *x2SumModifier;
@property (weak) IBOutlet NSStepper *stepper;
@property (weak) IBOutlet NSTextField *hLinesField;


- (IBAction)buttonTapped:(id)sender;
- (IBAction)valueChanged:(id)sender;

@property (weak) IBOutlet NSTextField *permutationsField;
@property (weak) IBOutlet SumView *sumView;

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


@end


