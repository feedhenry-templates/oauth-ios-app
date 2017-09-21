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

#import "GoogleAuthMethod.h"

@implementation GoogleAuthMethod

- (void) performAuthWithViewController:(UIViewController*) viewController
{
  FHAuthRequest* authRequest = [FH buildAuthRequest];
  [authRequest authWithPolicyId:policyId];
  authRequest.parentViewController = viewController;
  void (^success)(FHResponse *)=^(FHResponse * res){
#if DEBUG
    NSLog(@"parsed response %@ type=%@",res.parsedResponse,[res.parsedResponse class]);
#endif
    if ([[[res parsedResponse] valueForKey:@"status"] isEqualToString:@"error"]) {
      [self showMessage:@"Failed" message:[res.parsedResponse valueForKey:@"message"] viewController:viewController];
    } else {
      [self showMessage:@"Success" message:[res.parsedResponse JSONString] viewController:viewController];
    }
  };
  void (^failure)(FHResponse *)=^(FHResponse* res){
#if DEBUG
    NSLog(@"parsed response %@ type=%@",res.parsedResponse,[res.parsedResponse class]);
#endif
    [self showMessage:@"Failed" message:res.rawResponseAsString viewController:viewController];
  };

  [authRequest execAsyncWithSuccess:success AndFailure:failure];
}

- (void) showMessage:(NSString* )title message:(NSString*)msg viewController:(UIViewController*) viewController
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
  [viewController presentViewController:alertController animated:YES completion:nil];
  [alertController release];
}

@end
