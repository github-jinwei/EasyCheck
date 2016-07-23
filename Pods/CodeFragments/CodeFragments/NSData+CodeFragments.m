//
//  NSData+CodeFragments.m
//  LepaoBeads
//
//  Created by jinyu on 15/2/5.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import "NSData+CodeFragments.h"
#import "NSString+CodeFragments.h"

@implementation NSData (CodeFragments)

- (Byte*)crc16{
    Byte* bytes = (Byte*)[self bytes];  
    int crc = 0x00;
    int polynomial = 0x1021;
    for (int index = 0 ; index < self.length; index++) {
        int b = bytes[index];
        for (int i = 0; i < 8; i++) {
            BOOL bit = ((b   >> (7-i) & 1) == 1);
            BOOL c15 = ((crc >> 15    & 1) == 1);
            crc <<= 1;
            if (c15 ^ bit) crc ^= polynomial;
        }
    }
    crc &= 0xffff;
    
    NSString* s = [NSString stringWithFormat:@"%x", crc];
    while (s.length < 4) {
        s = [@"0" stringByAppendingString:s];
    }
    
    return (Byte*)[[s hexData] bytes];
}

NSInteger gen_crc16(Byte* bytes, NSUInteger length){
    unsigned char x;
    unsigned short crc = 0x1021;
    
    while (length--){
        x = crc >> 8 ^ *bytes++;
        x ^= x>>4;
        crc = (crc << 8) ^ ((unsigned short)(x << 12)) ^ ((unsigned short)(x <<5)) ^ ((unsigned short)x);
    }
    return crc;
}

@end
