//
//  VCTest3.h
//  Test3D
//
//  Created by gdlab on 12/12/3.
//
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "Test3DLayer.h"
#import "Test3DScene.h"
#import "CC3EAGLView.h"
#import "MainLayer.h"

@interface VCTest3 : UIViewController <UIAlertViewDelegate>
{
    CCDirector *director;
    
    UILabel *ulCountDownTime;
    NSTimer *tCountDownTimer;
    int iActionTime;
}
@property (retain, nonatomic) IBOutlet UIView *toolBar;
@property (retain, nonatomic) IBOutlet UILabel *ulCountDownTime;
@property (retain, nonatomic) IBOutlet UIView *smallView;

@end
