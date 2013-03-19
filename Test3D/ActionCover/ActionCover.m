//
//  ActionCover.m
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import "ActionCover.h"

@interface ActionCover ()

@end

@implementation ActionCover

@synthesize dic = _dic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    T1=FALSE;
    T2=FALSE;
    T3=FALSE;
    T4=FALSE;
    T5=FALSE;
    checkS=FALSE;
    sexstring = @"";//記錄是男生還是女生
    persondata = [[NSMutableDictionary alloc]init];
    df = [[NSDateFormatter alloc] init];
    male = [[RadioButton alloc]initWithGroupId:@"sex group" index:0];
    female = [[RadioButton alloc]initWithGroupId:@"sex group" index:1];
    
    male.frame = CGRectMake(185, 130, 33, 33);
    female.frame = CGRectMake(240, 130, 33, 33);
    
    
    [self.view addSubview:male];
    [self.view addSubview:female];
    
    [RadioButton addObserverForGroupId:@"sex group" observer:self]; //設定"性別"group
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(280, 340, 200, 40);
    [submitBtn setTitle:@"提交答案" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    _dic = [[NSMutableDictionary alloc] initWithCapacity:16];
    delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
    
	
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    NSLog(@"changed to %d in %@",index,groupId);
    [_dic setObject:[NSString stringWithFormat:@"%d",index+1] forKey:groupId];
    
    for (NSString *string in[self.dic allValues]) {
        sexstring = string;
        NSLog(@"性別：%@",sexstring);
        /*
        if ([string isEqualToString:@"1"]) {
            sexstring = @"男生";
            NSLog(@"性別：%@",sexstring);
        }
        else if ([string isEqualToString:@"2"]){
            sexstring = @"女生";
            NSLog(@"性別：%@",sexstring);
        }*/
        
        
    }
    
}

-(void)savePersonData:(NSString*)object :(NSString*)key{
    
    [persondata setObject:object forKey:key];
    
}

-(BOOL)checkwrite:(NSString*)object{
    if ([object isEqualToString:@""]) {
        return FALSE;
    }
    else{
        return TRUE;
    }
}

//存入個人資料到dictionary
-(void)setPersonData{
    
    delegate.TestNumberString = [NSString stringWithFormat:@"%@%@",[self setOnlyNumber],_StudentName.text];
    //NSLog(@"delegate testNumber %@",delegate.TestNumberString);
    [self savePersonData:_StudentName.text :@"StudentName"];
    [self savePersonData:sexstring :@"Sex"];
    [self savePersonData:_SchoolName.text :@"SchoolName"];
    [self savePersonData:_GradeYear.text :@"GradeYear"];
    [self savePersonData:_TestDay.text :@"TestDay"];
    [self savePersonData:_Birthday.text :@"Birthday"];
}

//確認每一格都有填到
-(void)checkAllwrite{
    
    T1 = [self checkwrite:_StudentName.text];
    T2 = [self checkwrite:_SchoolName.text];
    T3 = [self checkwrite:_GradeYear.text];
    T4 = [self checkwrite:_TestDay.text];
    T5 = [self checkwrite:_Birthday.text];
    NSLog(@"birthday :%d",T5);
    checkS = [self checkwrite:sexstring];
    
}
-(void)submitClick:(id)sender{
#if DEMO
    tellNext = [[UIAlertView alloc] initWithTitle:@"填寫個人資料" message:@"確定要下一頁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    tellNext.tag = 1;
    [tellNext show];
#else
    [self checkAllwrite];
    if (T1 &T2 &T3 &T4 &T5 &checkS) {
        NSLog(@"write down");
        tellNext = [[UIAlertView alloc] initWithTitle:@"填寫個人資料" message:@"確定要下一頁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
        tellNext.tag = 1;
        [tellNext show];
        
    }
    else{
        tellErr = [[UIAlertView alloc] initWithTitle:@"填寫個人資料" message:@"未填寫完成" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        tellErr.tag=2;
        [tellErr show];
    }
#endif
}
-(void)switchToAction1{
    
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT1"] animated:YES completion:Nil];
    
}
-(void)switchToActionEnd{
    
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACTend"] animated:YES completion:Nil];
    
}
-(void)datePickerAddToView{
    
    datePicker =[[UIDatePicker alloc]init];
    datePicker.frame = CGRectMake(20, 80, 240, 150);
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    dAlert = [[UIAlertView alloc] initWithTitle:@"日期" message:@"請選擇出生日期\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
    dAlert.frame = CGRectMake(0, 0, 600, 600);
    dAlert.delegate = self;
    dAlert.tag = 0;
    [dAlert addSubview:datePicker];
    [dAlert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 0:
            switch (buttonIndex) {
                case 0:
                    [self SetBirthday];
                    break;
            }
            break;
        case 1:
            //printf("alertView tag 2 ");
            switch (buttonIndex) {
                case 0:
                    break;
                case 1:
                    [self setPersonData];
                    saveFile = [[FileOPs alloc]init];
                    [saveFile saveToJsonFile:persondata];
                    [self switchToAction1];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            break;
        case 3:
            switch (buttonIndex) {
                case 0:
                    break;
                case 1:
                    [self switchToActionEnd];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

//按鈕按下後設定生日日期
-(void)SetBirthday{
    date  = [datePicker date];
    [df setDateFormat:(NSString*) @"yyyy-MM-dd "];
    _Birthday.text = [df stringFromDate:date];
    
}
//設定檔案名稱不重複
-(NSString *)setOnlyNumber{
    [df setDateFormat:(NSString*) @"yyyy-MM-ddHHmmssSS"];
    TestNumber = [df stringFromDate:[NSDate date]];
    NSLog(@"TestNumberstring %@,",TestNumber);
    return TestNumber;
}
- (IBAction)GoToUploadBtn:(id)sender {
    GoToUploadAlert = [[UIAlertView alloc] initWithTitle:@"上傳資料" message:@"確定前往上傳資料頁面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    GoToUploadAlert.tag = 3;
    [GoToUploadAlert show];
}

- (IBAction)TestDayBtn:(id)sender {
    [df setDateFormat:(NSString*) @"yyyy-MM-dd "];
    _TestDay.text =[df stringFromDate:[NSDate date]];
}

- (IBAction)BirthDayBtn:(id)sender {
    [self datePickerAddToView];
}
-(void)dealloc{
    NSLog(@"ActionCover release");
    [persondata release];
    [sexstring release];
    [datePicker release];
    [datestring release];
    [submitBtn release];
    [male release];
    [female release];
    [saveFile release];
    [df release];
    [date release];
    [tellErr release];
    [tellNext release];
    [dAlert release];
    [super dealloc];
}
@end
