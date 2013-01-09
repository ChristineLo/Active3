//
//  Action5ViewController.h
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "FileOPs.h"

@interface Action5ViewController : UIViewController<RadioButtonDelegate>{
    int disX;
    int disY;
    int startX;
    NSMutableDictionary *AnswerDic;
    FileOPs *saveFile;
}
@property (nonatomic,retain) NSMutableDictionary *dic;
-(IBAction)OK:(id)sender;

@end
