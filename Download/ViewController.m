//
//  ViewController.m
//  Download
//
//  Created by MAC on 15/1/8.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "DownloadData.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Download:(id)sender{
    //NSString *strURL = [[NSString alloc] initWithFormat: @"http://www.weather.com.cn/data/cityinfo/101010100.html"];
    NSString *strURL = [[NSString alloc] initWithFormat: @"http://123.57.72.120:8090/Server/DownServlet?key=124234352432523432423678"];
    // NSString *strURL = [[NSString alloc] initWithFormat: @"http://192.168.1.103:8080/Server/DownServlet?key=124234352432523432423678"];

    NSString *httpBody =[[NSString alloc] initWithFormat: @"{\"userid\":\"%@\",\"begintime\":\"%@\",\"endtime\":\"%@\"}",_userID.text,_beginTime.text,_endTime.text];
    NSLog(@"%@",httpBody);
    
    DownloadData *download_data = [DownloadData new];
    
    //[download_data getRequest:strURL];
    [download_data postRequest:strURL HTTPBody:httpBody];
}

@end
