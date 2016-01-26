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

#import "RootViewController.h"
#import "HelloViewController.h"
#import "AuthViewController.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  void (^success)(FHResponse *)=^(FHResponse * res){
    if(self.tabBarItem.tag == 101){
      HelloViewController * eventsController = [[HelloViewController alloc]init];
      [self pushViewController:eventsController animated:NO];
      [eventsController release];
    } else if(self.tabBarItem.tag == 102){
      AuthViewController * authViewController = [[AuthViewController alloc] init];
      [self pushViewController:authViewController animated:NO];
      [authViewController release];
    }
  };
  
  void (^failure)(id)=^(FHResponse * res){
    NSLog(@"FH init failed. Response = %@", res.rawResponse);
  };
  
  [FH initWithSuccess:success AndFailure:failure];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
