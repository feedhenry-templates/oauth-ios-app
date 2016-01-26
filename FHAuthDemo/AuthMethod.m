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

#import "AuthMethod.h"

@implementation AuthMethod

- (id) initWithName:(NSString*)_name icon:(NSString*)_iconName policyId:(NSString*)_policyId
{
  self = [super  init];
  if(self){
    name = [_name retain];
    iconName = [_iconName retain];
    policyId = [_policyId retain];
  }
  return self;
}

- (NSString*) getName
{
  return name;
}

- (NSString*) getIcon
{
  return iconName;
}

- (void) performAuthWithViewController:(UIViewController*) viewController
{
  //do nothing
}

-(void)dealloc{
  [name release];
  [iconName release];
  [policyId release];
  [super dealloc];
}
@end
