//
//  ViewController.h
//  Summer
//
//  Created by Chris Shreve on 11/14/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *numberField;
@property (weak) IBOutlet NSButton *actionButton;
@property (weak) IBOutlet NSTextField *x2Sum;
@property (weak) IBOutlet NSTextField *x4Sum;
- (IBAction)buttonTapped:(id)sender;
@property (weak) IBOutlet NSTextField *x1Sum;
@property (weak) IBOutlet NSTextField *ratio;
@property (weak) IBOutlet NSTextField *x2SumModifier;

@end

