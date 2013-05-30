//
//  VCTest4.h
//  Test3D
//
//  Created by Mac06 on 12/12/14.
//
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import "UIGlossyButton.h"
#import "addTeachWord.h"
#import "Test3DAppDelegate.h"

#define kFILE_ANS [NSString stringWithFormat:@"Active4-%d",backNum]
#define kMENU_HEIGHT 54

@interface VCTest4 : UIViewController <UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,addTeachWordDelegate>
{
    addTeachWord *addTeachingWord;
    UILabel *ulCountDownTime;
    UILabel *imgNumLabel;
    NSTimer *tCountDownTimer;
    int iActionTime;
    
    #pragma mark 繪圖view
    SmoothLineView *slv;
    UIImageView *frontImage;
    int backNum;
    
    UIPopoverController* activePopover;
    UIPopoverController *popover;
    
    UIImage *imageSaved;
    UIImage *imageOrigin;
}
@property (retain, nonatomic) IBOutlet UILabel *ulCountDownTime;
#pragma mark 繪圖view
@property (nonatomic,retain)  UIColor *curColor;
@property (nonatomic, retain) UIGlossyButton *undoButton;
@property (nonatomic, retain) UIGlossyButton *redoButton;
@property (nonatomic, retain) UIGlossyButton *clearButton;
@property (nonatomic, retain) UIGlossyButton *eraserButton;
@property (nonatomic, retain) UIGlossyButton *preButton;
@property (nonatomic, retain) UIGlossyButton *nextButton;
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
