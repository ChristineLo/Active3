//
//  Action5ViewController.h
//  CreatTest
//
//  Created by Mac04 on 13/1/3.
//  Copyright (c) 2013年 Mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "FileOPs.h"

@interface Action5ViewController : UIViewController<RadioButtonDelegate>{
    int disX;
    int disY;
    int startX;
    UIImage *image;
    UIImageView *imageView;
    NSMutableDictionary *AnswerDic;
    FileOPs *saveFile;
    UIScrollView *scrollView;
    UIAlertView *notWritedown;
    UIStoryboard *Storyboard;
}
@property (nonatomic,retain) NSMutableDictionary *dic;
- (IBAction)OK:(id)sender;
@end
