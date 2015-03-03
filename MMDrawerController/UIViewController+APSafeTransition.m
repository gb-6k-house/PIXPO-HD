//
//  UIViewController+APSafeTransition.m
//
//  https://github.com/nexuspod/SafeTransition
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 WenBi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "UIViewController+APSafeTransition.h"
#import "MMNavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (APSafeTransition)

+ (void)load
{
    Method m1;
    Method m2;

    m1 = class_getInstanceMethod(self, @selector(sofaViewDidAppear:));
    m2 = class_getInstanceMethod(self, @selector(viewDidAppear:));
    method_exchangeImplementations(m1, m2);
    
}

- (void)sofaViewDidAppear:(BOOL)animated
{
    if ([self.navigationController isKindOfClass:[MMNavigationController class]]) {
        
        self.navigationController.transitionInProgress = NO;
        [self sofaViewDidAppear:animated];
    }

}

@end
