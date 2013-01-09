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
    T0=FALSE;
    T1=FALSE;
    T2=FALSE;
    T3=FALSE;
    T4=FALSE;
    T5=FALSE;
    checkS=FALSE;
    sexstring = @"";//記錄是男生還是女生
    persondata = [[NSMutableDictionary alloc]init];
    
    RadioButton *male = [[RadioButton alloc]initWithGroupId:@"sex group" index:0];
    RadioButton *female = [[RadioButton alloc]initWithGroupId:@"sex group" index:1];
    
    male.frame = CGRectMake(190, 135, 22, 22);
    female.frame = CGRectMake(250, 135, 22, 22);
    
    
    [self.view addSubview:male];
    [self.view addSubview:female];
    
    [RadioButton addObserverForGroupId:@"sex group" observer:self]; //設定"性別"group
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(280, 340, 200, 40);
    [submitBtn setTitle:@"提交答案" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    _dic = [[NSMutableDictionary alloc] initWithCapacity:16];
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
	
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    NSLog(@"changed to %d in %@",index,groupId);
    [_dic setObject:[NSString stringWithFormat:@"%d",index+1] forKey:groupId];
    
    for (NSString *string in[self.dic allValues]) {
        if ([string isEqualToString:@"1"]) {
            sexstring = @"男生";
            NSLog(@"性別：%@",sexstring);
        }
        else if ([string isEqualToString:@"2"]){
            sexstring = @"女生";
            NSLog(@"性別：%@",sexstring);
        }
        
        
    }
    
}

-(void)savePersonData:(NSString*)object :(NSString*)key{
    
    [persondata setObject:object forKey:key];
    //NSLog(@"%@-----------------------------",persondata);
    
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
    [self savePersonData:_TestNumber.text :@"TestNumber"];
    delegate.TestNumberString = _TestNumber.text;
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
    T0 = [self checkwrite:_TestNumber.text];
    T1 = [self checkwrite:_StudentName.text];
    T2 = [self checkwrite:_SchoolName.text];
    T3 = [self checkwrite:_GradeYear.text];
    T4 = [self checkwrite:_TestDay.text];
    T5 = [self checkwrite:_Birthday.text];
    NSLog(@"birthday :%d",T5);
    checkS = [self checkwrite:sexstring];
    
}
-(void)submitClick:(id)sender{
    [self checkAllwrite];
    //[self switchToAction1];
    if (T0 &T1 &T2 &T3 &T4 &T5 &checkS) {
        NSLog(@"write down");
        UIAlertView *tellNext = [[UIAlertView alloc] initWithTitle:@"填寫個人資料" message:@"確定要下一頁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
        tellNext.tag = 1;
        [tellNext show];
        
    }
    else{
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:@"填寫個人資料" message:@"未填寫完成" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        tellErr.tag=2;
        [tellErr show];
    }
}
-(void)switchToAction1{
    
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT1"] animated:YES completion:Nil];
}

-(void)datePickerAddToView{
    
    datePicker =[[UIDatePicker alloc]init];
    datePicker.frame = CGRectMake(20, 80, 240, 150);
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIAlertView *dAlert = [[UIAlertView alloc] initWithTitle:@"日期" message:@"請選擇出生日期\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
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
        default:
            break;
    }
}

//按鈕按下後設定生日日期
-(void)SetBirthday{
    NSDate *date  = [datePicker date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:(NSString*) @"yyyy-MM-dd "];
    _Birthday.text = [dateFormatter stringFromDate:date];
    
}
- (IBAction)TestDayBtn:(id)sender {
    //[self datePickerAddToView:_TestYear];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:(NSString*) @"yyyy-MM-dd "];
    _TestDay.text =[df stringFromDate:[NSDate date]];
}

- (IBAction)BirthDayBtn:(id)sender {
    [self datePickerAddToView];
}

@end
