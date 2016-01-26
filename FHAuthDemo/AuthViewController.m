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

#import "AuthViewController.h"
#import "AuthMethod.h"
#import "FHAuthMethod.h"
#import "GoogleAuthMethod.h"

@interface AuthViewController ()

@end

@implementation AuthViewController
@synthesize authList, authMethods;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  self.navigationItem.title = @"Login With ...";
  [super viewDidLoad];
  AuthMethod* fhauth = [[FHAuthMethod alloc] initWithName:@"FeedHenry" icon:@"auth_feedhenry" policyId:@"MyFeedHenryPolicy"];
  AuthMethod* googleauth = [[GoogleAuthMethod alloc] initWithName:@"Google OAuth" icon:@"auth_google" policyId:@"Google"];
  AuthMethod* mbaasauth = [[FHAuthMethod alloc] initWithName:@"FeedHenry MBAAS" icon:@"auth_feedhenry" policyId:@"MBaaSServiceAuthPolicy"];
  self.authMethods = [NSArray arrayWithObjects:fhauth, googleauth, mbaasauth, nil];
    
  [authList reloadData];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
  
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [authMethods count];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString * cellid = @"cellid";
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
  if(cell == nil){
    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] autorelease];
  }
  NSInteger idx = [indexPath row];
  AuthMethod* method = [self.authMethods objectAtIndex:idx];
  cell.textLabel.text = (NSString *)[method getName];
  NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:[method getIcon] ofType:@"png"];
  UIImage* img = [UIImage imageWithContentsOfFile:path];
  cell.imageView.image = img;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
  NSInteger idx = [indexPath row];
  AuthMethod* method = [self.authMethods objectAtIndex:idx];
  [method performAuthWithViewController:self.parentViewController];
  [authList deselectRowAtIndexPath:indexPath animated:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
  [authMethods release];
  [authList release];
  [super dealloc];
}

@end
