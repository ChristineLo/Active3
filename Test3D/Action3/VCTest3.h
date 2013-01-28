//
//  VCTest3.h
//  Test3D
//
//  Created by gdlab on 12/12/3.
//
//

#import <UIKit/UIKit.h>
#import "addTeachWord.h"
#import "SmoothLineView.h"
#import "UIGlossyButton.h"

#import "Test3DLayer.h"
#import "Test3DScene.h"
#import "CC3EAGLView.h"
#import "MainLayer.h"

enum
{
	THREE_D					= 0x0000,
	TWO_D					= 0x0001,
};

#define kFILE_ANS [NSString stringWithFormat:@"Active3-%d",backNum]
#define kMENU_HEIGHT 0
#define COLOR_BD [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f]
#define COLOR_BS [UIColor redColor]

@interface VCTest3 : UIViewController<UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, addTeachWordDelegate>
{
    int editState;
    NSArray *twoDButtons;
    NSArray *threeDButtons;
    
    addTeachWord *addTeachingWord;
    UILabel *ulCountDownTime;
    NSTimer *tCountDownTimer;
    int iActionTime;
    
#pragma mark 繪圖view
    SmoothLineView *slv;
    UIImageView *backImage;
    int backNum;
    
#pragma mark 3DView
    CCDirector *director;
    MainLayer *threeDLayer;
}

#pragma mark 3DView
@property (retain, nonatomic) IBOutlet UIView *toolBar;
@property (retain, nonatomic) IBOutlet UILabel *ulCountDownTime;
@property (retain, nonatomic) IBOutlet UIView *smallView;

#pragma mark 繪圖view
@property (nonatomic,retain)  UIColor *curColor;
@property (nonatomic, retain) UIGlossyButton *undoButton;
@property (nonatomic, retain) UIGlossyButton *redoButton;
@property (nonatomic, retain) UIGlossyButton *clearButton;
@property (nonatomic, retain) UIGlossyButton *eraserButton;
@property (nonatomic, retain) UIGlossyButton *whitePenButton;
@property (nonatomic, retain) UIGlossyButton *blackPenButton;
@property (nonatomic, retain) UIGlossyButton *defaultButton;
@property (nonatomic, retain) UIGlossyButton *rotateButton;
@property (nonatomic, retain) UIGlossyButton *depthButton;
@property (nonatomic, retain) UIGlossyButton *switchButton;


-(void) initButton;
-(void) initQuest;

-(void) setUndoButtonEnable:(NSNumber*)isEnable;
-(void) setRedoButtonEnable:(NSNumber*)isEnable;
-(void) setClearButtonEnable:(NSNumber*)isEnable;
-(void) setEraserButtonEnable:(NSNumber*)isEnable;
-(void) setWhitePenButtonEnable:(NSNumber*)isEnable;
-(void) setBlackPenButtonEnable:(NSNumber*)isEnable;
-(IBAction)rotateButtonClicked:(id)sender;
-(IBAction)depthButtonClicked:(id)sender;
-(IBAction)switchEditStateButtonClicked:(id)sender;
-(IBAction)save2FileButtonClicked:(id)sender;

@end
