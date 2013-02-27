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
    //slv = [[SmoothLineView alloc] initWithFrame:CGRectMake(0, 0, 768, 970)];
    slv.delegate = self;
    [self.view addSubview:slv];
    
    
    [self initQuest];
    [self initButton];
    
    self.curColor = [UIColor blackColor];
    
    [super viewDidLoad];
    addTeachingWord = [[addTeachWord alloc] init];
    [addTeachingWord addTeachingWordString:@"     「人」是個文字也是個圖形，在這個測驗裡是要你把「人」當成圖形而不是文字看待。下面總共有五十七個大小不盡相同的「人」形，看你在十分鐘之內能畫出多少的圖畫，人形必須是你所畫圖畫中的一部份，畫好之後請在每一幅圖畫下面畫線處寫出所畫圖形的名稱。記住，你所畫的圖畫不能是中文字。(十分鐘)" title:@"活動四"];
    //[addTeachingWord addTeachingWordImage:@"TeachingWord4.png" :120 :30 :620 :160];
    addTeachingWord.delegate = self;
    [self.view addSubview:addTeachingWord.view];
    [self addChildViewController:addTeachingWord];
    
#if DEMO
    UIButton *skipButton = (UIButton*) [self.view viewWithTag: 2001];
    [skipButton addTarget:self action:@selector(timeIsUpHandle) forControlEvents:UIControlEventTouchUpInside];
    if (skipButton == NULL) {
        NSLog(@"button is null");
    }
#endif
}

-(void)StartCountDownTimer:(id)sender {
    UIAlertView *tellTimeStart = [[UIAlertView alloc] initWithTitle:@"活動四" message:@"十分鐘計時開始!!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    tellTimeStart.tag = 0;
    [tellTimeStart show];
}

-(void) startAction{
    [addTeachingWord.view removeFromSuperview];
    [addTeachingWord removeFromParentViewController];
    [addTeachingWord release];
    
    iActionTime = 600;
    //[ulCountDownTime setTextColor:[UIColor whiteColor]];
    [self setCoundDownLabel];
    tCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setCoundDownLabel) userInfo:NULL repeats:YES];
    
    [self addTextField];
}

-(void) addTextField {
    int w,h,dx,dy;
    w = 250;
    h = 40;
    dx = 450;
    dy = 370;
    UITextField *tmp = [[UITextField alloc] initWithFrame:CGRectMake(20, 300, w, h)];
    [tmp setTag:3001];
    [tmp setBorderStyle:UITextBorderStyleLine];
    [tmp setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    [slv addSubview:tmp];
    tmp = [[UITextField alloc] initWithFrame:CGRectMake(20+dx, 300, w, h)];
    [tmp setTag:3002];
    [tmp setBorderStyle:UITextBorderStyleLine];
    [tmp setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    [slv addSubview:tmp];
    tmp = [[UITextField alloc] initWithFrame:CGRectMake(20, 300+dy, w, h)];
    [tmp setTag:3003];
    [tmp setBorderStyle:UITextBorderStyleLine];
    [tmp setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    [slv addSubview:tmp];
    tmp = [[UITextField alloc] initWithFrame:CGRectMake(20+dx, 300+dy, w, h)];
    [tmp setTag:3004];
    [tmp setBorderStyle:UITextBorderStyleLine];
    [tmp setFont:[UIFont fontWithName:@"ArialMT" size:30]];
    [slv addSubview:tmp];
}

-(void) cleanTextField {
    for (int i = 3001; i < 3005; ++i) {
        UITextField *tmp = (UITextField*)[self.view viewWithTag:3001];
        tmp.text = @"";
    }
}

//到數計時
-(void) setCoundDownLabel {
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
//alert view
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 0:
            if (buttonIndex == 1) {
                [self startAction];
            }
            break;
        case 1:
            //結束
            if(buttonIndex == 0) {
                [self save2FileButtonClicked:NULL];
                [self switchNextAction];
            }
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

- (void) initTextFeild
{
    UITextField *tmp = (UITextField*) [self.view viewWithTag:3001];
    [tmp removeFromSuperview];
    [tmp setText:@""];
    [self.view addSubview:tmp];
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
    //NSFileManager *fileMgr = [[NSFileManager alloc] init];
    Test3DAppDelegate *delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.png",delegate.TestNumberString,[NSString stringWithFormat:@"Active4-%d",Num]]];
    UIImage *image;
    
    if (backImage != NULL) {
        [slv removeFromSuperview];
        slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + kMENU_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - kMENU_HEIGHT)] autorelease];
        slv.delegate = self;
        [self.view addSubview:slv];
        [backImage removeFromSuperview];
        //[backImage release];
    }
    
    image = [UIImage imageNamed:[NSString stringWithFormat:@"action4%02d.png",Num]];
    UIImage *imageSaved = [UIImage imageWithContentsOfFile:pngPath];
    if (imageSaved)
        [slv loadFromAlbumButtonClicked:imageSaved];
    else{
        [slv loadFromAlbumButtonClicked:image];
    }
    
    [self addTextField];
    
    backImage = [[UIImageView alloc] initWithImage:image];
    [backImage setFrame:CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y, backImage.frame.size.width, backImage.frame.size.height)];
    [slv addSubview:backImage];
    [image release];
    
    (Num == 1) ? [self setPreButtonEnable:[NSNumber numberWithBool:NO]] : [self setPreButtonEnable:[NSNumber numberWithBool:YES]];

    (Num == 14) ? [self setNextButtonEnable:[NSNumber numberWithBool:NO]] : [self setNextButtonEnable:[NSNumber numberWithBool:YES]];

}

-(void) nextQuest {
    if (backNum < 14) {
        [self save2FileButtonClicked:self];
        [self setQuesImage:++backNum];
        [self cleanTextField];
    }
}

-(void) preQuest {
    if (backNum > 1) {
        [self save2FileButtonClicked:self];
        [self setQuesImage:--backNum];
        [self cleanTextField];
        /*
        NSFileManager *mgr = [[NSFileManager alloc] init];
        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Screenshot %@.png",kFILE_ANS]];
        if([mgr fileExistsAtPath:pngPath isDirectory:NO])
        {
            UIImage *image = [UIImage imageWithContentsOfFile:pngPath];
            [slv loadFromAlbumButtonClicked:image];
            //[image release];
        }
        [mgr release];
         */
    }
}

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

-(IBAction)save2FileButtonClicked:(id)sender
{
    //[slv save2FileButtonClicked];
    Test3DAppDelegate *delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
    //NSLog(@"%@",delegate.TestNumberString);
    [slv save2File:kFILE_ANS filefolder:delegate.TestNumberString];
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
