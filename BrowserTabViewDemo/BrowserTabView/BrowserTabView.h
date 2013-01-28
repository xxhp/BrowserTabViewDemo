//
//  BrowserTab.h
//  BrowserTabDemo
//
//  Created by xiao haibo on 9/9/12.
//  Copyright (c) 2012 xiao haibo. All rights reserved.

//  github:https://github.com/xxhp/BrowserTabViewDemo
//  Email:xiao_hb@qq.com

//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@class BrowserTabView;

@protocol BrowserTabViewDelegate <NSObject>

@optional

- (void)BrowserTabView:(BrowserTabView *)browserTabView didSelecedAtIndex:(NSUInteger)index;
- (void)BrowserTabView:(BrowserTabView *)browserTabView willRemoveTabAtIndex:(NSUInteger)index;
- (void)BrowserTabView:(BrowserTabView *)browserTabView didRemoveTabAtIndex:(NSUInteger)index;
- (void)BrowserTabView:(BrowserTabView *)browserTabView exchangeTabAtIndex:(NSUInteger)fromIndex withTabAtIndex:(NSUInteger)toIndex;
- (BOOL)browserTabView:(BrowserTabView *)tabView shouldChangeTitle:(NSString *)title;

@end

@interface BrowserTabView : UIView <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, readonly) NSUInteger numberOfTabs;
@property (nonatomic, readonly) NSInteger selectedTabIndex;

@property (nonatomic, readonly) NSMutableArray *reuseQueue;
@property (nonatomic, weak) id<BrowserTabViewDelegate> delegate;

- (id)initWithTabTitles:(NSArray *)titles andDelegate:(id)adelegate;
- (void)addTabWithTitle:(NSString *)title;
- (void)setSelectedTabIndex:(NSInteger)aSelectedTabIndex animated:(BOOL)animation;
- (void)removeTabAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
