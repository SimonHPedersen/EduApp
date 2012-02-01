//
//  Question.m
//  EduApp
//
//  Created by Thomas Kristensen on 2/1/12.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "Question.h"

@implementation Question
@synthesize leftOperand=_leftOperand;
@synthesize rightOperand=_rightOperand;

- (id) initWithLeftOperand:(int) leftOperand andRightOperand:(int) rightOperand {
    self = [super init];
    if (self) {
        self.leftOperand = leftOperand;
        self.rightOperand = rightOperand;
    }
    return self;
}

- (NSString*) questionText {
    return [NSString stringWithFormat:@"%d + %d", self.leftOperand, self.rightOperand];
}

@end
