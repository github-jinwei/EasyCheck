//
//  NSTimer+CodeFragments.h
//  CodeFragment
//
//  Created by jinyu on 15/2/4.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CodeFragments)


+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

-(void)pauseTimer;
-(void)resumeTimer;

@end
