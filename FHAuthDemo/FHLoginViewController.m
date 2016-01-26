/*
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <FH/FH.h>

#import "FHLoginViewController.h"

@interface FHLoginViewController ()

@end

@implementation FHLoginViewController
@synthesize usernameField, passwordField, spinner, loginButton;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil policyId:(NSString*) policy;
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    policyId = [policy retain];
  }
  return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.usernameField)
  {
    // Move input focus to the password field.
    [self.passwordField becomeFirstResponder];
  }
  else
  {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    // Simulate clicking the Submit button.
    [self.loginButton becomeFirstResponder];
  }
  return NO;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.spinner.hidden = YES;
  self.usernameField.delegate = self;
  self.passwordField.delegate = self;
  [self.usernameField becomeFirstResponder];
    BOOL hasSession = [FH hasAuthSession];
    if (hasSession) {
        self.logoutButton.hidden = false;
    } else {
        self.logoutButton.hidden = true;
    }

}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [self releaseOutlets];
}

-(void) releaseOutlets
{
  self.usernameField = nil;
  self.passwordField = nil;
  self.loginButton = nil;
  self.spinner = nil;
}

- (void) setIsWaiting:(BOOL)waiting
{
  if(waiting){
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    self.loginButton.enabled = NO;
  } else {
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
    self.loginButton.enabled = YES;
  }
}

- (IBAction)submit:(id)sender
{
  NSString* userName = self.usernameField.text;
  if(!userName){
    return [self showMessage:@"Error" message:@"User Name field is required"];
  }
  NSString* password = self.passwordField.text;
  if(!password){
    return [self showMessage:@"Error" message:@"Password field is required"];
  }
  [self setIsWaiting:YES];
  FHAuthRequest* authRequest = [FH buildAuthRequest];
  [authRequest authWithPolicyId:policyId UserId:userName Password:password];
  void (^success)(FHResponse *)=^(FHResponse * res){
    [self setIsWaiting:NO];
#if DEBUG
    NSLog(@"parsed response %@ type=%@",res.parsedResponse,[res.parsedResponse class]);
#endif
    if ([[[res parsedResponse] valueForKey:@"status"] isEqualToString:@"error"]) {
      [self showMessage:@"Failed" message:[res.parsedResponse valueForKey:@"message"]];
    } else {
      [self showMessage:@"Success" message:res.rawResponseAsString];
    }
  };
  void (^failure)(FHResponse *)=^(FHResponse* res){
    [self setIsWaiting:NO];
#if DEBUG
    NSLog(@"parsed response %@ type=%@",res.parsedResponse,[res.parsedResponse class]);
#endif
    [self showMessage:@"Failed" message:res.rawResponseAsString];
  };
  [authRequest execAsyncWithSuccess:success AndFailure:failure];
}

- (IBAction)logout:(id)sender {
    [FH clearAuthSessionWithSuccess:nil AndFailure:nil];
}

- (void) showMessage:(NSString* )title message:(NSString*)msg 
{
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
  [self.usernameField release];
  [self.passwordField release];
  [self.loginButton release];
  [self.spinner release];
  [policyId release];
    [_logoutButton release];
  [super dealloc];
}

@end
