//
//  ViewController.h
//  Download
//
//  Created by MAC on 15/1/8.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *URLLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *userID;

- (IBAction)Download:(id)sender;

@end

