//
//  EPAddQuestionDelegateProtocol.h
//  AgileToolbox
//
//  Created by Marcin Czenko on 7/13/12.
//  Copyright (c) 2012 Everyday Productive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EPAddQuestionDelegateProtocol <NSObject>

- (void)questionAdded:(NSString*)question;

@end
