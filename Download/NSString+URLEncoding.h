//
//  NSString+URLEncoding.h
//  Download
//
//  Created by MAC on 15/1/8.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#ifndef Download_NSString_URLEncoding_h
#define Download_NSString_URLEncoding_h

@interface NSString (URLEncoding)

-(NSString *)URLEncodedString;
-(NSString *)URLDecodedString;

@end

@implementation NSString (URLEncoding)

-(NSString *)URLEncodedString
{
    NSString* result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                      (kCFAllocatorDefault,
                       (CFStringRef)self,
                       NULL,
                       CFSTR("+$,#[] "),
                       kCFStringEncodingUTF8));
    return result;
}

-(NSString *)URLDecodedString;
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding
                      (kCFAllocatorDefault,
                       (CFStringRef)self,
                       CFSTR(""),
                       kCFStringEncodingUTF8));
    return result;
}
@end

#endif
