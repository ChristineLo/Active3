//
//  VCTest4.m
//  Test3D
//
//  Created by Mac06 on 12/12/14.
//
//

#import "VCTest4.h"

@implementation VCTest4
@synthesize ulCountDownTime;
@synthesize undoButton;
@synthesize redoButton;
@synthesize clearButton;
@synthesize eraserButton;
@synthesize save2FileButton;
@synthesize save2AlbumButton;
@synthesize loadFromAlbumButton;
@synthesize preButton;
@synthesize nextButton;
@synthesize curColor;

- (void)viewDidLoad
{
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + kMENU_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - kMENU_HEIGHT)] autorelease];
    slv.delegate = self;
    [self.view addSubview:slv];
    
    [self initButton];
    [self initQuest];
    
    self.curColor = [UIColor blackColor];
    
    [super viewDidLoad];
    addTeachingWord = [[addTeachWord alloc] init];
    [addTeachingWord addTeachingWordImage:@"TeachingWord4.png" :120 :30 :620 :160];
    addTeachingWord.delegate = self;
    [self.view addSubview:addTeachingWord.view];
    [self addChildViewController:addTeachingWord];
    
#if DEMO
    UIButton *skipButton = (UIButton*) [self.view viewWithTag: 2001];
    [skipButton addTarget:self action:@selector(switchNextAction) forControlEvents:UIControlEventTouchUpInside];
    if (skipButton == NULL) {
        NSLog(@"button is null");
    }
#endif
}

-(void)StartCountDownTimer:(id)sender {
    [addTeachingWord.view removeFromSuperview];
    [addTeachingWord removeFromParentViewController];
    [addTeachingWord release];
    
    iActionTime = 600;
    //[ulCountDownTime setTextColor:[UIColor whiteColor]];
    [self setCoundDownLabel];
    tCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setCoundDownLabel) userInfo:NULL repeats:YES];
}

//到數計時
-(void) setCoundDownLabel {
    NSLog(@"timer %d",iActionTime);
    [ulCountDownTime setText:[NSString stringWithFormat:@"%02d:%02d",iActionTime/60,iActionTime%60]];
    if (iActionTime == 10) {
        [ulCountDownTime setTextColor:[UIColor redColor]];
    }
    else if (iActionTime < 1) {
        NSLog(@"timer remove");
        [tCountDownTimer invalidate];
        [self timeIsUpHandle];
    }
    --iActionTime;
}

//填寫完成，時間停止
-(void) timeIsUpHandle{
    
    UIAlertView *tellTimeStop = [[UIAlertView alloc] initWithTitle:@"活動三" message:@"時間到，停止作答!!\n進入下一活動" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    tellTimeStop.tag = 1;
    [tellTimeStop show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self save2FileButtonClicked:NULL];
            [self switchNextAction];
            //[self saveAnswerText];
            break;
    }
}

//進入活動三頁面
-(void) viewDidDisappear:(BOOL)animated {
    [tCountDownTimer invalidate];
}

-(void)switchNextAction{
    
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT5"] animated:YES completion:Nil];
}

-(void)setButtonAttrib:(UIGlossyButton*)_button
{
    [_button useWhiteLabel: YES];
    _button.buttonCornerRadius = 2.0; _button.buttonBorderWidth = 1.0f;
	[_button setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    _button.tintColor = _button.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

- (void) initButton
{
    undoButton = (UIGlossyButton*) [self.view viewWithTag: 1001];
    [self setButtonAttrib:undoButton];
    
    redoButton = (UIGlossyButton*) [self.view viewWithTag: 1002];
    [self setButtonAttrib:redoButton];
    
    clearButton = (UIGlossyButton*) [self.view viewWithTag: 1003];
    [self setButtonAttrib:clearButton];
    
    eraserButton = (UIGlossyButton*) [self.view viewWithTag: 1004];
    [self setButtonAttrib:eraserButton];
    
    preButton = (UIGlossyButton*) [self.view viewWithTag: 1005];
    [self setButtonAttrib:preButton];
    
    nextButton = (UIGlossyButton*) [self.view viewWithTag: 1006];
    [self setButtonAttrib:nextButton];
    
    save2FileButton = (UIGlossyButton*) [self.view viewWithTag: 1007];
    [self setButtonAttrib:save2FileButton];
}

-(void) initQuest {
    backNum = 1;
    [self setQuesImage:backNum];
}

-(void)  setQuesImage :(int) Num {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"action4%02d.png",backNum]];
    
    if (backImage != NULL) {
        [slv clearButtonClicked];
        [backImage removeFromSuperview];
        [backImage release];
    }
    
    backImage = [[UIImageView alloc] initWithImage:image];
    [backImage setFrame:CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y+80, backImage.frame.size.width, backImage.frame.size.height)];
    [slv addSubview:backImage];
    [image release];
    
    (Num == 1) ? [self setPreButtonEnable:[NSNumber numberWithBool:NO]] : [self setPreButtonEnable:[NSNumber numberWithBool:YES]];

    (Num == 14) ? [self setNextButtonEnable:[NSNumber numberWithBool:NO]] : [self setNextButtonEnable:[NSNumber numberWithBool:YES]];

}

-(void) nextQuest {
    if (backNum < 14) {
        [self save2FileButtonClicked:self];
        [self setQuesImage:++backNum];
    }
}

-(void) preQuest {
    if (backNum > 1) {
        [self setQuesImage:--backNum];
        
        NSFileManager *mgr = [[NSFileManager alloc] init];
        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Screenshot %@.png",kFILE_ANS]];
        if([mgr fileExistsAtPath:pngPath isDirectory:NO])
        {
            UIImage *image = [UIImage imageWithContentsOfFile:pngPath];
            [slv loadFromAlbumButtonClicked:image];
            //[image release];
        }
        [mgr release];
    }
}

/*
//- (void) applyPickedColor: (InfColorPickerController*) picker
- (void) applyPickedColor
{
    
    float red,green,blue,alpha;
    
    //self.curColor = picker.resultColor;
    [self.curColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [slv setColor:0 g:0 b:0 a:0];
}
*/
#pragma mark	UIPopoverControllerDelegate methods
//------------------------------------------------------------------------------

- (void) popoverControllerDidDismissPopover: (UIPopoverController*) popoverController
{
    /*
	if( [ popoverController.contentViewController isKindOfClass: [ InfColorPickerController class ] ] ) {
		InfColorPickerController* picker = (InfColorPickerController*) popoverController.contentViewController;
		[ self applyPickedColor: picker ];
	}*/
	
	if( popoverController == activePopover ) {
		[ activePopover release ];
		activePopover = nil;
	}
}

//------------------------------------------------------------------------------
/*
- (void) showPopover: (UIPopoverController*) popover from: (id) sender
{
	popover.delegate = self;
	
	activePopover = [ popover retain ];
	
	if( [ sender isKindOfClass: [ UIBarButtonItem class ] ] ) {
		[ activePopover presentPopoverFromBarButtonItem: sender
							   permittedArrowDirections: UIPopoverArrowDirectionAny
											   animated: YES ];
	}
	else {
		UIView* senderView = sender;
		
		[ activePopover presentPopoverFromRect: [ senderView bounds ]
										inView: senderView
					  permittedArrowDirections: UIPopoverArrowDirectionAny
									  animated: YES ];
	}
}
*/
//------------------------------------------------------------------------------

- (BOOL) dismissActivePopover
{
	if( activePopover ) {
		[ activePopover dismissPopoverAnimated: YES ];
		[ self popoverControllerDidDismissPopover: activePopover ];
		
		return YES;
	}
	
	return NO;
}

/*
//------------------------------------------------------------------------------
#pragma mark	InfHSBColorPickerControllerDelegate methods
//------------------------------------------------------------------------------

- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) picker
{
    [ self applyPickedColor: picker ];
}

//------------------------------------------------------------------------------

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
	[ self applyPickedColor: picker ];
    
	[ activePopover dismissPopoverAnimated: YES ];
}
*/

#pragma mark Button Click Event
-(IBAction)nextButtonClicked:(id)sender
{
    [self nextQuest];
}

-(IBAction)preButtonClicked:(id)sender
{
    [self preQuest];
}

-(IBAction)undoButtonClicked:(id)sender
{
    [slv undoButtonClicked];
    
}

-(IBAction)redoButtonClicked:(id)sender
{
    [slv redoButtonClicked];
    
}

-(IBAction)clearButtonClicked:(id)sender
{
    [slv clearButtonClicked];
    
}

-(IBAction)eraserButtonClicked:(id)sender
{
    [slv eraserButtonSwitchClicked];
    (eraserButton.tintColor == [UIColor redColor])?[eraserButton setTintColor:redoButton.tintColor]:[eraserButton setTintColor:[UIColor redColor]];
}

/*
-(IBAction)changeColorClicked:(id)sender
{
    if( [ self dismissActivePopover ] )
		return;
	
	InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
	
	picker.sourceColor = self.curColor;
	picker.delegate = self;
	
	UIPopoverController* popover = [ [ [ UIPopoverController alloc ] initWithContentViewController: picker ] autorelease ];
	
	[ self showPopover: popover from: sender ];
}
*/
-(IBAction)save2FileButtonClicked:(id)sender
{
    //[slv save2FileButtonClicked];
    [slv save2File:kFILE_ANS];
}

-(IBAction)save2AlbumButtonClicked:(id)sender
{
    [slv save2AlbumButtonClicked];
    
}

-(IBAction)loadFromAlbumButtonClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [popover presentPopoverFromRect:CGRectMake(654.0, 1.0f, 1.0, 1.0)
                             inView:slv
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
}
#pragma mark UIImagePickerControllerDelegate Handle
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [popover dismissPopoverAnimated:YES];
    [slv loadFromAlbumButtonClicked:image];
    [popover release];
    
}

#pragma mark toolbarDelegate
-(void) setUndoButtonEnable:(NSNumber*)isEnable
{
    [undoButton setEnabled:[isEnable boolValue]];
}
-(void) setRedoButtonEnable:(NSNumber*)isEnable
{
    [redoButton setEnabled:[isEnable boolValue]];
}
-(void) setClearButtonEnable:(NSNumber*)isEnable
{
    [clearButton setEnabled:[isEnable boolValue]];
}
-(void) setEraserButtonEnable:(NSNumber*)isEnable
{
    [eraserButton setEnabled:[isEnable boolValue]];
}
-(void) setSave2FileButtonEnable:(NSNumber*)isEnable
{
    [save2FileButton setEnabled:[isEnable boolValue]];
}
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable
{
    [save2AlbumButton setEnabled:[isEnable boolValue]];
}
-(void) setNextButtonEnable:(NSNumber*)isEnable
{
    [nextButton setEnabled:[isEnable boolValue]];
}

-(void) setPreButtonEnable:(NSNumber*)isEnable
{
    [preButton setEnabled:[isEnable boolValue]];
}

@end
