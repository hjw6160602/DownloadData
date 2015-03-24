//
//  DownloadData.m
//  Download
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "NSString+URLEncoding.h"
#import "DownloadData.h"

@implementation DownloadData

- (void) getRequest:(NSString *)strURL{
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    
    if(connection)
    {
        _datas = [NSMutableData new];
        NSLog(@"异步请求成功");
    }
}

- (void) postRequest:(NSString *)strURL HTTPBody:(NSString *)httpBody{
    NSData *postData = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    //将httpBody转为流 NSInputStream
    NSInputStream *postDataStream;
    if(postData){
        postDataStream = [NSInputStream inputStreamWithData:postData];}
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];  //
    
    //判断httpBody的流是否为空
    if(postData)
    {
        // [request setHTTPBodyStream: postDataStream];  //向服务器发送流
        
        [request setHTTPBody: postData];  //设置向服务器发送的数据
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        _datas = [NSMutableData new];
        NSLog(@"异步请求成功");
    }
}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"收到Response");
    //将NSURLResponse对象转换成NSHTTPURLResponse对象
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *responseHeaders = [httpResponse allHeaderFields];
    NSLog(@"%@",responseHeaders);
    _ContentType = [responseHeaders valueForKey:@"Content-Type"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_datas appendData:data];
    NSLog(@"%@",_datas);
    NSLog(@"data数据获取成功！");
    
    if([_ContentType  isEqual: @"application/json;charset=UTF-8"])
        [self JSONDecode:data];
    else if([_ContentType isEqual: @"application/zip"])
        [self Write2File];
}


- (void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
}


- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成...");
}


-(void)JSONDecode:(NSData *)data{
    NSError *error;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers
                                                   error:&error];
    
    if(!jsonObj || error){
        NSLog(@"JSON解码失败！");
    }
    
    self.listData = jsonObj;
    
    //类型转换
    id errorID = [self.listData valueForKey:@"error"];
    NSString *Error = [NSString stringWithFormat:@"%@",errorID];
    NSString *message = [self.listData valueForKey:@"message"];
    
    NSMutableString* JSON=[[NSMutableString alloc] initWithString:@"\n"];
    [JSON appendString:@"错误消息: "];
    [JSON appendString:Error];
    [JSON appendString:@"\n错误内容： "];
    [JSON appendString:message];
    
    
    NSLog(@"%@",self.listData);
    
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle: @"提示"
                                                          message:JSON
                                                         delegate:nil
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles: @"确定",nil];
    [myAlertView show];
}

- (void)Write2File{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *file=@"/Users/mac/Desktop/Download.zip";
    NSData *filePath=[fm contentsAtPath:file];
    if(![fm fileExistsAtPath:file])
        [fm createFileAtPath:file contents:filePath attributes:nil];
    [_datas writeToFile:file atomically:YES];
}

@end