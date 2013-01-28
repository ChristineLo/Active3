//
//  EndViewController.h
//  CreatTest
//
//  Created by Mac04 on 13/1/9.
//  Copyright (c) 2013年 Mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "FileOPs.h"



#define COOKBOOK_PURPLE_COLOR    [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR)     [[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

@interface EndViewController : UIViewController{
    UILabel *networkLabel ,*giveupLabel,*successLabel;
    NSTimer *timer;
    FileOPs *readFile;
    NSMutableArray *ActDicArray,*UploadArray;
    UIButton *UploadBtn,*DeleteBtn,*ReturnBtn;
    UIAlertView *tellError,*tellNoData;
    UIStoryboard *Stroyboard;
    int numOfFile;
    int fileCount;
}

@end
