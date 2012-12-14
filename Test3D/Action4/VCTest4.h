//
//  VCTest4.h
//  Test3D
//
//  Created by Mac06 on 12/12/14.
//
//

#import <UIKit/UIKit.h>
#import "Test3DLayer.h"
#import "Test3DScene.h"
#import "CC3EAGLView.h"
#import "MainLayer.h"

@interface VCTest4 : UIViewController <UIAlertViewDelegate>
{
    CCDirector *director;
    
    UILabel *ulCountDownTime;
    NSTimer *tCountDownTimer;
    int iActionTime;
}
@end
