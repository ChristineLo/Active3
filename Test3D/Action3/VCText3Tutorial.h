//
//  VCText3Tutorial.h
//  Test3D
//
//  Created by gdlab on 12/12/27.
//
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import "UIGlossyButton.h"

#import "Test3DLayer.h"
#import "Test3DScene.h"
#import "CC3EAGLView.h"
#import "MainLayer.h"

#define kFILE_ANS [NSString stringWithFormat:@"Active3-%d",backNum]
#define kMENU_HEIGHT 0

@interface VCText3Tutorial : UIViewController<UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
#pragma mark 繪圖view
    SmoothLineView *slv;
    UIImageView *backImage;
    int backNum;
    
#pragma mark 3DView    
    CCDirector *director;
    UILabel *ulCountDownTime;
    NSTimer *tCountDownTimer;
    int iActionTime;
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

@property (nonatomic, retain) UIGlossyButton *save2FileButton;
@property (nonatomic, retain) UIGlossyButton *save2AlbumButton;
@property (nonatomic, retain) UIGlossyButton *loadFromAlbumButton;


-(void) initButton;
-(void) initQuest;

-(void) setUndoButtonEnable:(NSNumber*)isEnable;
-(void) setRedoButtonEnable:(NSNumber*)isEnable;
-(void) setClearButtonEnable:(NSNumber*)isEnable;
-(void) setEraserButtonEnable:(NSNumber*)isEnable;
-(void) setSave2FileButtonEnable:(NSNumber*)isEnable;
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable;

@end
