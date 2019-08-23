//
//  LoginVC.m
//  BarberApp
//
//  Created by Pankaj Asudani on 03/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import "LoginVC.h"
#import "HomeVC.h"
#import "ForgotPasswordVC.h"

@interface LoginVC ()<UIGestureRecognizerDelegate>

//Middle transparent view
@property (nonatomic, weak) IBOutlet UIView *loginVw;

//EMAIL Field
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

//PASSWORD Field
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

-(void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
//    _emailTextField.text = @"info@livininthecut.com";//@"shawman@yopmail.com";
//    _passwordTextField.text = @"seminars31";//@"236858";
    
        _emailTextField.text = @"EliteBarbers@yopmail.com";
        _passwordTextField.text = @"711911";
    
    
    NSString *userEmailStr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL];
    NSString *userPasswordStr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PASSWORD];
    
    if (userEmailStr != nil){
        _emailTextField.text = userEmailStr;
    }
    
    if (userPasswordStr != nil){
        _passwordTextField.text = userPasswordStr;
    }
}

-(void) setUpView{

    _loginVw.layer.cornerRadius = 10.0f;
    
    //SetUp HTTP initially
    _httpServiceObject = [[HTTPService alloc] init];
    NSString *baseURLString = BASE_URL;
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLSessionConfiguration *urlSession = [NSURLSessionConfiguration defaultSessionConfiguration];
    _httpServiceObject = [[HTTPService alloc] initWithBaseURL:baseURL andSessionConfig:urlSession];
    
    //Add a tap Gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark- SingleTapGesture Selector

-(void) singleTap{

    [self.view endEditing:YES];
}

#pragma mark- IBAction Methods

-(IBAction)loginBtnPressed:(id)sender{

    [self.view endEditing:YES];

    if ([CommonFunctions connectedToNetwork]) {
        
        if ([self validate]) {
            
            //Call Webservice
            [CommonFunctions showActivityIndicatorWithText:@"LoggingIn.." detailedText:@"Please Wait"];
            [self loadApi];
        }
    }
    else
    {
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    }
    
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField.tag == 0) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:1];
        [passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Webservice Method

-(void) loadApi{

    /**
     *{"email":"nimtej@yopmail.com","password":"123456"}
     */
    
    //API Parameter dictionary
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_emailTextField.text,@"email",_passwordTextField.text,@"password", nil];
    
    [_httpServiceObject startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:nil withServiceName:@"login" withParameters:paramDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"response - %@",responseObject);
        
        NSDictionary *responseDictionary = (NSDictionary*)responseObject;
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        
        if (statusCode == 200) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseDictionary forKey:USER_INFO];
            
            [[NSUserDefaults standardUserDefaults] setObject:_emailTextField.text forKey:USER_EMAIL];
            [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //Move to Home View
            [self navigateToHomeVC];
        }
        else
        {
            [CommonFunctions alertTitle:@"Tonic" withMessage:[NSString stringWithFormat:@"%@",[[responseDictionary objectForKey:@"data"] objectForKey:@"msg"]]];
        }
        
        [CommonFunctions removeActivityIndicator];
        
    } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error - %@",[error localizedDescription]);
        [CommonFunctions removeActivityIndicator];
    }];
}

#pragma mark- Other Method

-(void) navigateToHomeVC{
    
    HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    [self.navigationController showViewController:homeVC sender:nil];
}

#pragma mark- Validation

-(BOOL) validate{

    BOOL isValid = TRUE;
    
    if (_emailTextField.text.length <= 0) {
        
        isValid = FALSE;
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"EMAIL_BLANK", nil)];
    }
    else if (![Validate isValidEmailId:_emailTextField.text]){
        
        isValid = FALSE;
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"EMAIL_INVALID", nil)];
    }
    else if (_passwordTextField.text.length <= 0){
        
        isValid = FALSE;
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"PASSWORD_BLANK", nil)];
    }
    
    return isValid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
