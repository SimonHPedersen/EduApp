//
//  Question.h
//  EduApp
//
//  Created by Thomas Kristensen on 2/1/12.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property int leftOperand;
@property int rightOperand;

- (NSString*) questionText;
- (id) initWithLeftOperand:(int) leftOperand andRightOperand:(int) rightOperand;

@end
