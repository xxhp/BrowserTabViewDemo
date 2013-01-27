//
//  BrowserTabController.m
//
//  BrowserTab.m
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

//TODO:changed kDefaultFrame to support iPhone
#define kDefaultFrame CGRectMake(0,0,1024,44)

//define overlap width between tabs
#define OVERLAP_WIDTH 15
#define TAB_FOOTER_HEIGHT 5
#define DEFAULT_TAB_WIDTH 154

static NSString *kReuseIdentifier = @"UserIndentifier";

#import "BrowserTabView.h"
#import "BrowserTab.h"

@interface BrowserTabView ()

@property(nonatomic, strong) NSMutableArray *tabsArray;
@property(nonatomic, strong) NSMutableArray *tabFramesArray;

- (void)caculateFrame;

@end

@implementation BrowserTabView

#pragma mark - init

- (id)initWithTabTitles:(NSArray *)titles andDelegate:(id)aDelegate
{
    if ([super init]) {
        
        
        
        self.frame = kDefaultFrame;
        
        _tabFramesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.backgroundImage = [UIImage imageNamed:@"tab_background"];
        
        _tabsArray = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        
        for (int i = 0;i< titles.count ;i++) {
            BrowserTab *tab = [[BrowserTab alloc] initWithReuseIdentifier:kReuseIdentifier andDelegate:self];
            tab.width = _tabWidth;
            tab.index = i;
            tab.titleField.text = titles[i];
            tab.delegate = self;
            [_tabsArray addObject:tab];
        }
        
        //background color is the same color of tab when been selected.
        self.backgroundColor =[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        _tabWidth = self.bounds.size.width /(_tabsArray.count+1);
        
        if (_tabWidth < DEFAULT_TAB_WIDTH) {
            _tabWidth = DEFAULT_TAB_WIDTH;
        }
        [self caculateFrame];
        
        _reuseQueue = [[NSMutableArray alloc] init];
        _delegate = aDelegate;
        
        if ([self.tabsArray count]) {
            [self setSelectedTabIndex:0 animated:NO];
        }
        
    }
    return self;
}

- (void)setTabWidth:(CGFloat)tabWidth {
    _tabWidth = tabWidth;
    for (BrowserTab *tab in self.tabsArray) {
        tab.width = tabWidth;
    }
    [self caculateFrame];
    [self setSelectedTabIndex:_selectedTabIndex animated:NO];
}
- (NSUInteger)numberOfTabs
{
	return [self.tabsArray count];
}

- (void)setSelectedTabIndex:(NSInteger)aSelectedTabIndex animated:(BOOL)animation
{
    BOOL selectNewPage= aSelectedTabIndex != _selectedTabIndex;
    
    _selectedTabIndex = aSelectedTabIndex;
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:didSelecedAtIndex:)] && selectNewPage) {
        [self.delegate BrowserTabView:self didSelecedAtIndex:aSelectedTabIndex];
    }
    
    //tabs before the selected are added in sequence from the first to the selected ;
    for (NSInteger tabIndex = 0; tabIndex < _selectedTabIndex; tabIndex++) {
        
        NSValue *tabFrameValue = [_tabFramesArray objectAtIndex:tabIndex];
        CGRect tabFrame = [tabFrameValue CGRectValue];
        BrowserTab *tab = [_tabsArray objectAtIndex:tabIndex];
        if (animation) {
            [UIView beginAnimations:nil context:nil];
            tab.frame = tabFrame;
            tab.delegate = self;
            [tab setSelected:NO];
            [UIView commitAnimations];
        }else{
            
            tab.frame = tabFrame;
            tab.delegate = self;
            [tab setSelected:NO];
        }
        
        [self addSubview:tab];
        
    }
    
    //tabs after the selected are added in sequence from the last to the selected ;
    for (NSInteger tabIndex = (self.numberOfTabs - 1); tabIndex >= _selectedTabIndex; tabIndex--) {
        
        BrowserTab *tab = [_tabsArray objectAtIndex:tabIndex];
        if (self.selectedTabIndex == tabIndex) {
            [tab setSelected:YES];
        }else{
            [tab setSelected:NO];
        }
        
        NSValue *tabFrameValue = [_tabFramesArray objectAtIndex:tabIndex];
        CGRect tabFrame = [tabFrameValue CGRectValue];
        if (animation) {
            [UIView beginAnimations:nil context:nil];
            tab.frame = tabFrame;
            [UIView commitAnimations];
        }else{
            tab.frame = tabFrame;
            
        }
        [self addSubview:tab];
    }
    
}
// use tabs from the queue
- (BrowserTab *)dequeueTabUsingReuseIdentifier:(NSString *)reuseIdentifier
{
    BrowserTab *reuseTab = nil;
    
    for (BrowserTab *tab in _reuseQueue) {
        
        if ([tab.reuseIdentifier isEqualToString:reuseIdentifier]) {
            
            reuseTab = tab;
            break;
            
        }
        
    }
    if (reuseTab != nil) {
        [_reuseQueue removeObject:reuseTab];
    }
    
    [reuseTab prepareForReuse];
    
    return reuseTab;
    
}

- (void)addTabWithTitle:(NSString *)title
{
    //if the new tab is about to be off the tab view's bounds , here simply not adding it ;
    if (self.tabWidth < DEFAULT_TAB_WIDTH) {
        self.tabWidth = DEFAULT_TAB_WIDTH;
    }
    if (self.tabWidth >DEFAULT_TAB_WIDTH) {
        self.tabWidth = DEFAULT_TAB_WIDTH;
    }
    
    if (self.tabWidth * (self.numberOfTabs+1) - OVERLAP_WIDTH * (self.numberOfTabs -1)> self.bounds.size.width) {
        return;
    }else{
        _tabWidth = self.bounds.size.width /(self.numberOfTabs+1);
    }
    if (!title) {
		title = @"new Tab";
	}
    
    BrowserTab *tab = [self dequeueTabUsingReuseIdentifier:kReuseIdentifier];
    if (tab) {
        tab.delegate = self;
    }else{
        
        tab = [[BrowserTab alloc] initWithReuseIdentifier:kReuseIdentifier andDelegate:self];
    }
    tab.titleField.text = title;
    tab.frame = CGRectZero;
    
	[self.tabsArray addObject:tab];
    
    for (int i = 0; i < [_tabsArray count]; i++) {
        BrowserTab *tab = [_tabsArray objectAtIndex:i];
        tab.index = i;
        tab.selected = NO;
    }
    
    [self caculateFrame];
    
    _selectedTabIndex = [self.tabsArray count]-1;
    NSValue *tabFrameValue = [_tabFramesArray lastObject];
    CGRect tabFrame = [tabFrameValue CGRectValue];
    
    tab.frame = tabFrame;
    tab.selected = YES;
    
    [self setSelectedTabIndex:_selectedTabIndex animated:NO];
}


- (void)removeTabAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0 || index >= [_tabsArray count]) {
        return;
    }
    BrowserTab *tab = [_tabsArray objectAtIndex:index];
    //the last one tab not allowed to remove,return;
    NSUInteger newIndex = tab.index;
    
    
    
    
    if (self.numberOfTabs == 1 || !self.numberOfTabs) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:willRemoveTabAtIndex:)]) {
        [self.delegate BrowserTabView:self willRemoveTabAtIndex:index];
    }
    //if previous selected index was the last tab ,keep the coming last one selected
    if (index == self.numberOfTabs-1) {
        newIndex = index -1;
    }
    
    [_reuseQueue addObject:[_tabsArray objectAtIndex:index]];
    [_tabsArray removeObject:tab];
    
    [tab removeFromSuperview];
    
    _tabWidth = self.bounds.size.width /(self.numberOfTabs+1);
    NSInteger tabIndex = 0;
    for (BrowserTab *tab in _tabsArray) {
        
        tab.index = tabIndex;
        
        tabIndex++;
        
    }
    
    [self caculateFrame];
    if(index == self.numberOfTabs){
        [ self setSelectedTabIndex:newIndex animated:NO];
    }
    else{
        [ self setSelectedTabIndex:newIndex animated:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:didRemoveTabAtIndex:)]) {
        [self.delegate BrowserTabView:self didRemoveTabAtIndex:index];
    }
    
}

- (void)caculateFrame
{
    const float overlapWidth = OVERLAP_WIDTH ;
    CGFloat height = self.bounds.size.height;
    CGFloat right = 0;
    
    [_tabFramesArray removeAllObjects];
    
    for (NSInteger tabIndex = 0; tabIndex <self.numberOfTabs; tabIndex++) {
        CGRect tabFrame = CGRectMake(right, 0, self.tabWidth, height - TAB_FOOTER_HEIGHT);
        [_tabFramesArray addObject:[NSValue valueWithCGRect:tabFrame]];
        right += (self.tabWidth - overlapWidth);
    }
    
}

- (void)drawRect:(CGRect)rect {
    CGFloat height = self.bounds.size.height;
	
    //left 5 dp to show the background, and give a look that tab has footer
	[_backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, height - TAB_FOOTER_HEIGHT)];
}

#pragma mark - UIPanGestureRecognizer

- (void)handlePanGuesture:(UIPanGestureRecognizer *)sender {
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	//// The following algorithm for handling panguesture inspired from  https://github.com/graetzer/SGTabs
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    BrowserTab *panTab = (BrowserTab *)sender.view;
    NSUInteger panPosition = [self.tabsArray indexOfObject:panTab];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self setSelectedTabIndex:panPosition animated:NO];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint position = [sender translationInView:self];
        CGPoint center = CGPointMake(sender.view.center.x + position.x, sender.view.center.y);
        
        // Don't move the tab out of the tabview
        if (center.x < self.bounds.size.width-5  &&  center.x > 5) {
            sender.view.center = center;
            [sender setTranslation:CGPointZero inView:self];
            CGFloat width = self.tabWidth;
            // If more than half the tab width is moved, exchange the positions
            if (abs(center.x - width*panPosition - width/2) > width/2) {
                NSUInteger nextPos = position.x > 0 ? panPosition+1 : panPosition-1;
                if (nextPos >= self.numberOfTabs)
                    return;
                
                BrowserTab *nextTab = [self.tabsArray objectAtIndex:nextPos];
                if (nextTab) {
                    if (_selectedTabIndex == panPosition)
                        _selectedTabIndex = nextPos;
                    [self.tabsArray exchangeObjectAtIndex:panPosition withObjectAtIndex:nextPos];
                    
                    for (int i = 0; i < [_tabsArray count]; i++) {
                        BrowserTab *tab = [_tabsArray objectAtIndex:i];
                        tab.index = i;
                        tab.selected = NO;
                        if (i == _selectedTabIndex) {
                            tab.selected = YES;
                        }
                    }
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        nextTab.frame = CGRectMake(width*panPosition + 5, 0, width, self.bounds.size.height - 5);
                        
                        if ([self.delegate respondsToSelector:@selector(BrowserTabView:exchangeTabAtIndex:withTabAtIndex:)]) {
                            [self.delegate BrowserTabView:self exchangeTabAtIndex:panPosition withTabAtIndex:nextPos];
                        }
                        
                    }];
                }
            }
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3 animations:^{
            panTab.center = CGPointMake(panTab.center.x , panTab.center.y);
            [self setSelectedTabIndex:_selectedTabIndex animated:YES];
        }];
    }
}

#pragma mark - LongTap

- (void)handleLongPress:(UILongPressGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateRecognized) {
        BrowserTab *tab = (BrowserTab *)[gr view];
        tab.titleField.enabled = YES;
        [tab.titleField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = YES;
    if ([self.delegate respondsToSelector:@selector(browserTabView:shouldChangeTitle:)]) {
        result = [self.delegate browserTabView:self shouldChangeTitle:textField.text];
    }
    if (result) {
        BrowserTab *tab = self.tabsArray[_selectedTabIndex];
        tab.title = textField.text;
        textField.enabled = NO;
    }
    return result;
}

@end
