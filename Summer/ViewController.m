//
//  ViewController.m
//  Summer
//
//  Created by Chris Shreve on 11/14/15.
//  Copyright © 2015 C. Shreve. All rights reserved.
//

#import "ViewController.h"
#import "MyPoint.h"
#import <math.h>


@interface ViewController ()

@property NSMutableArray *components;
@property NSMutableArray *permutations;
@property NSMutableArray *adjustedPermutations;
@property NSMutableArray *hLines;
@property NSMutableArray *vLines;
@property NSMutableArray *data;
@property NSMutableArray *approximationPoints;
@property double mean;
@property double variance;
@property double stdDev;
@property double stdDev1Percent;
@property double stdDev2Percent;

@end;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self.view.window makeFirstResponder:self];

    self.scaleYCheckbox.state = YES;
    self.sumView.scaleY = self.gridCheckbox.state;
    
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
    self.stdDev2PercentValue.stringValue = @"";
    
    
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
//    [self calculateRandom];
    
    [self readHLines];
    [self readVLines];
    
    [self calculatePermutations];

    
    [self calculateStuff];
    [self calculateStats];
    [self calculateApproximation];
    [self.stepper setIntegerValue:0];


    self.sumView.components = self.components;
    self.sumView.mean = self.mean;
    self.sumView.variance = self.variance;
    
    self.sumView.permutations = self.permutations;
    self.sumView.hLines = self.hLines;
    self.sumView.vLines = self.vLines;
    self.sumView.approximationPoints = self.approximationPoints;
    
    [self.sumView setNeedsDisplay:YES];
}

-(void) readComponents {
    self.components = [[NSMutableArray alloc] init];
    
    NSString *text = self.numberField.stringValue;
    NSArray *components = [text componentsSeparatedByString:@","];
    for (NSString *c in components) {
        NSNumber *n = [NSNumber numberWithInteger:[c integerValue]];
//        NSInteger *value = [c intValue];
//        [self.components addObject:value];
//        [self.components addObject:intValue];
        [self.components addObject:n];
    }
}

-(void)calculateRandom {
    NSMutableArray *randomComponents = [[NSMutableArray alloc] init];
    
    int r1 = arc4random_uniform(20);
    int r2 = r1 + arc4random_uniform(20);
    [randomComponents addObject:[NSNumber numberWithInteger:r1]];
    [randomComponents addObject:[NSNumber numberWithInteger:r2]];
    
    int sum = r1 + r2;
    int lastRandom = r2;
//    int lowerBound = r1 + r2;
    for (int i=2; i<[self.components count]; i++) {
        NSLog(@"sum = %d", sum);
        // bigger than previous number, less than sum
        int newRandom = lastRandom + arc4random_uniform(sum - lastRandom + 1);
        NSLog(@"newRandom = %d", newRandom);
        NSNumber *n = [NSNumber numberWithInteger:newRandom];
        sum = sum + newRandom;
        lastRandom = newRandom;
        [randomComponents addObject:n];
    }
    
    self.components = randomComponents;
    self.numberField.stringValue = [self.components componentsJoinedByString:@","];
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
            NSNumber *newPermutation = [NSNumber numberWithInteger:([p integerValue] + [n integerValue])];
//            NSNumber *newPermutation = [p decimalNumberByAdding: n];
            [tempPerms addObject:newPermutation];
        }
        
        
        self.permutations = tempPerms;
    }
    self.adjustedPermutations = self.permutations;
    self.permutationsField.stringValue = [self.adjustedPermutations componentsJoinedByString:@","];
}

-(void) calculateStuff {

    long x1sum = 0;
    long x1AbsSum = 0;
    long x2sum = 0;
    long x3sum = 0;
    long x4sum = 0;
    self.data = [[NSMutableArray alloc] init];
    for (NSNumber *s in self.adjustedPermutations) {
        NSInteger n = [s integerValue];
        x1sum += n;
        x1AbsSum += abs((int)n);
        x2sum += pow(n, 2);
        x3sum += pow(n, 3);
        x4sum += pow(n, 4);
    }
    
    self.x1Sum.stringValue = [NSString stringWithFormat:@"%ld", x1sum];
    self.x1AbsSum.stringValue = [NSString stringWithFormat:@"%ld", x1AbsSum];
    self.x2Sum.stringValue = [NSString stringWithFormat:@"%ld", x2sum];
    self.x3Sum.stringValue = [NSString stringWithFormat:@"%ld", x3sum];
    self.x4Sum.stringValue = [NSString stringWithFormat:@"%ld", x4sum];
    
    
    // calculate averages
    double permutations =  pow(2, (int)[self.components count]);
    double x2StdDeviation = pow(x2sum/permutations, 0.5);
    self.x2stdDeviation.stringValue = [NSString stringWithFormat:@"%f", x2StdDeviation];
    
    double absAverage = x1AbsSum / permutations;
    self.xabsAverage.stringValue = [NSString stringWithFormat:@"%f", absAverage];
    
    double x1Average = x1sum / permutations;
    self.xAverage.stringValue = [NSString stringWithFormat:@"%f", x1Average];
    
    double approxAvg = [self calculateApproximationAverage];
    self.approxAverage.stringValue = [NSString stringWithFormat:@"%f", approxAvg];
    
    
    // calculate ratios
    
    double ratio12 = (1.0 * x2sum)/x1sum;
    self.ratio12.stringValue = [NSString stringWithFormat:@"%lf", ratio12];

    double ratio23 = (1.0 * x3sum)/x2sum;
    self.ratio23.stringValue = [NSString stringWithFormat:@"%lf", ratio23];
    
    double ratio34 = (1.0 * x4sum)/x3sum;
    self.ratio34.stringValue = [NSString stringWithFormat:@"%lf", ratio34];
    
    
    double ratio24 = (1.0 * x4sum)/x2sum;
    self.ratio24.stringValue = [NSString stringWithFormat:@"%lf", ratio24];
    
    
    NSLog(@"uh");
}

-(double) calculateApproximationAverage
{
    NSInteger v = -1*[self.stepper integerValue];
    
    NSLog(@"T = %ld", (long)v);
    
    NSLog(@"points = %@", self.approximationPoints);
    MyPoint *belowPoint = nil;
    MyPoint *abovePoint = nil;
    for (int i=0; i<[self.approximationPoints count]; i++) {
        MyPoint *point = [self.approximationPoints objectAtIndex:i];
        if (point.point.y <= v) {
            belowPoint = point;
        }
        if (point.point.y > v) {
            abovePoint = point;
            break;
        }
    }
    NSLog(@"above point = %f, %f", abovePoint.point.x, abovePoint.point.y);
    NSLog(@"below point = %f, %f", belowPoint.point.x, belowPoint.point.y);
    
    return 0.17;
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
    self.variance = variance;
    self.varianceValue.stringValue = [NSString stringWithFormat:@"%f", variance];
    
    
    // calculate std dev
    self.stdDev = sqrt(variance);
    self.stdDevValue.stringValue = [NSString stringWithFormat:@"%f", self.stdDev];
    
    // calculate percent of values between u - o and u + o
    int std1Count,std2Count = 0;
    for (NSNumber *p in self.permutations) {
        double n = [p doubleValue];
        if ( ((self.mean - self.stdDev) <= n) && (n <= (self.mean + self.stdDev)) ) {
            std1Count++;
        }
        if ( ((self.mean - 2.0*self.stdDev) <= n) && (n <= (self.mean + 2.0*self.stdDev)) ) {
            std2Count++;
        }
        
    }
    NSLog(@"count within u - o and u + o = %d", std1Count);
    self.stdDev1Percent = (double)std1Count/(double)[self.permutations count];
    self.stdDev2Percent = (double)std2Count/(double)[self.permutations count];
    self.stdDevPercentValue.stringValue = [NSString stringWithFormat:@"%f", self.stdDev1Percent];
    self.stdDev2PercentValue.stringValue = [NSString stringWithFormat:@"%f", self.stdDev2Percent];
}


-(void)calculateApproximation
{
    self.approximationPoints = [[NSMutableArray alloc] init];
    NSMutableArray *complementPoints = [[NSMutableArray alloc] init];
    NSInteger n = [self.components count];
    
    double upperBound = self.mean;
    NSNumber *number = [self.permutations objectAtIndex:2];
    double lowerBound = [number doubleValue];
    double range = (upperBound - lowerBound);
    double step = range/n;
    double xScale = pow(2, n);
    
    double cdfX  = 0;
    for (int i = 1; i<=n; i++) {
        cdfX = lowerBound + (i * step);
        double cdfY = [self CDFWithMean:self.mean variance:self.variance x:cdfX];
        MyPoint *p = [[MyPoint alloc] init];
        p.point =  CGPointMake(cdfY*xScale, cdfX);
        [self.approximationPoints addObject:p];
        
        if (i != n) {
            double comCDFX = pow(2,n-1) + (pow(2, n-1) - cdfY*xScale);
            double comCDFY = self.mean + (self.mean - cdfX);
            MyPoint *comp = [[MyPoint alloc] init];
            comp.point = CGPointMake(comCDFX, comCDFY);
            [complementPoints insertObject:comp atIndex:0];
        }
    }
    
    // add complement
    [self.approximationPoints addObjectsFromArray:complementPoints];
    
    NSLog(@"approximation = %@", self.approximationPoints);
    NSLog(@"");
}

-(double) CDFWithMean:(double)mean variance:(double)variance x:(double)x
{
    return 0.5 * erfc(((mean - x)/sqrt(variance)) * M_SQRT1_2);
}

- (IBAction)valueChanged:(id)sender {
    NSStepper *stepper = (NSStepper *)sender;
    NSInteger v = [stepper integerValue];

    self.adjustedPermutations = [[NSMutableArray alloc] init];
    
    for (NSString *p in self.permutations) {
        NSInteger adjustedValue = [p integerValue] + v;
        
        NSString *val = [NSString stringWithFormat:@"%ld", adjustedValue];
        [self.adjustedPermutations addObject:val];
        
//        NSString *abs = [NSString stringWithFormat:@"%ld", labs(adjustedValue)];
//        [self.adjustedPermutations addObject:abs];
    }
    NSLog(@"adjusted perm = %@", self.adjustedPermutations);
    
    self.permutationsField.stringValue = [self.adjustedPermutations componentsJoinedByString:@","];
    
    [self calculateStuff];
}

- (IBAction)makeDataTapped:(id)sender
{
//    [self doFileStuff];
    [self moarWriteToFile];
}

-(void)doFileStuff
{
    NSFileHandle *file;
    //object for File Handle
    NSError *error;
    //crearing error object for string with file contents format
    NSMutableData *writingdatatofile;
    
    
    //create mutable object for ns data
    NSString *filePath=[NSString stringWithFormat:@"/Users/cshreve/cks9247/data/doc.txt"];
    //telling about File Path for Reading for easy of access
    file = [NSFileHandle fileHandleForReadingAtPath:@"/Users/cshreve/cks9247/data/doc.txt"];
    
    //assign file path directory
    if (file == nil) //check file exist or not
        NSLog(@"Failed to open file");
    
    NSString *getfileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    //access file contents with out ns handle method
    if (error) //check error flag for file present or not
        NSLog(@"Error reading file: %@", error.localizedDescription);
    NSLog(@"**** DATA ****");
    NSLog(@"%@", getfileContents);
    NSLog(@"**** DATA ****");
    
    //display file contents in main file
    NSArray *listArray = [getfileContents componentsSeparatedByString:@"\n"];
    //caluculate list of line present in files
    NSLog(@"items = %ld", [listArray count]);
    
    
    
    const char *writingchar = "how are you";
    writingdatatofile = [NSMutableData dataWithBytes:writingchar length:strlen(writingchar)];
    
    //convert string format into ns mutable data format
    file = [NSFileHandle fileHandleForUpdatingAtPath: @"/Users/cshreve/cks9247/data/new.txt"];
    
    //set writing path to file
    if (file == nil) //check file present or not in file
        NSLog(@"Failed to open file");
    
    [file seekToFileOffset: 6];
    
    //object pointer initialy points the offset as 6 position in file
    [file writeData: writingdatatofile];
    
    //writing data to new file
    [file closeFile];
    //close the file
    
}
-(void)moarWriteToFile
{
    
    NSString *str = [NSString stringWithFormat:@"%@\n",@"blargeherhe"]; //get text from textField
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt",
//                          documentsDirectory];
    
    NSString *fileName = @"/Users/cshreve/cks9247/data/new.txt";
    
    // check for file exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileName]) {
        
        // the file doesn't exist,we can write out the text using the  NSString convenience method
        
        NSError *error = noErr;
        BOOL success = [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
            // handle the error
            NSLog(@"%@", error);
        }
        
    } else {
        
        // the file already exists, append the text to the end
        
        // get a handle
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
        // move to the end of the file
        [fileHandle seekToEndOfFile];
        
        // convert the string to an NSData object
        NSData *textData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        // write the data to the end of the file
        [fileHandle writeData:textData];
        
        // clean up
        [fileHandle closeFile];
    }
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
    self.sumView.components = self.components;
    [self.sumView setNeedsDisplay:YES];
}

- (IBAction)scaleYCheckboxTapped:(id)sender {
    self.sumView.scaleY = self.scaleYCheckbox.state;
    [self.sumView setNeedsDisplay:YES];
}

@end
