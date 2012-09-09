//
//  BrowserTabController.m
//  BrowserTabDemo
//
//  Created by xiaohaibo on 9/9/12.
//  Copyright (c) 2012 xiaohaibo. All rights reserved.

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
//define width of a tab ,here is the width of the image used to render tab;
#define TAB_WIDTH 154 
//define overlap width between tabs
#define OVERLAP_WIDTH 15
#define TAB_FOOTER_HEIGHT 5

#import "BrowserTabView.h"

@implementation BrowserTabView
@synthesize tabSelectedImage,tabNormalImage,tabViewBackImage;
@synthesize selectedTabIndex,numberOfTabs;
@synthesize tabTitlesArray,tabTitleFramesArray,tabFramesArray;
@synthesize titleFont;
@synthesize selectedTitleColor;
@synthesize normalTitleColor;
@synthesize delegate;

-(id)initWithTabTitles:(NSArray *)titles andDelegate:(id)aDelegate
{
    self = [super init];
    if (self) {
        self.frame = kDefaultFrame;
        
        tabTitleFramesArray = [[NSMutableArray alloc]initWithCapacity:0 ];
        tabFramesArray = [[NSMutableArray alloc]initWithCapacity:0 ];
        
        self.tabViewBackImage = [UIImage imageNamed:@"tab_background.png"]; 
        self.tabSelectedImage = [UIImage imageNamed:@"tab_selected.png"]; 
        self.tabNormalImage = [UIImage imageNamed:@"tab_normal.png"] ;
        self.tabTitlesArray = [NSMutableArray arrayWithArray:titles];  
        
        self.normalTitleColor = [UIColor whiteColor];
        self.selectedTitleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:18];
        
        //background color is the same color of tab when been selected.
        self.backgroundColor =[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        
        [self caculateFrame];
        
        delegate = aDelegate;
        
        if ([self.tabTitlesArray count]) {
            [self setSelectedTabIndex:0];
        }
        
    }
    return self;
}

- (NSUInteger)numberOfTabs
{
	return [self.tabTitlesArray count];
}
-(void)setSelectedTabIndex:(NSInteger)aSelectedTabIndex
{
    selectedTabIndex = aSelectedTabIndex;
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:didSelecedAtIndex:)]) {
        [self.delegate BrowserTabView:self didSelecedAtIndex:aSelectedTabIndex];
    }
    [self setNeedsDisplay];
}

- (void)addTabWithTitle:(NSString *)title 
{
    //if the new tab is about to be off the tab view's bounds , here simply not adding it ;
    if (TAB_WIDTH *(self.numberOfTabs+1)> self.bounds.size.width) {
        return;
    }
    
	if (!title) {
		title = @"new Tab";
	}
	[self.tabTitlesArray addObject:title];
    [self caculateFrame];
    self.selectedTabIndex = [self.tabTitlesArray count]-1;
    
}


- (void)removeTabAtIndex:(NSUInteger)index 
{
    //the last one tab not allowed to remove,return;
    NSUInteger newIndex = index;
    if (self.numberOfTabs == 1 || !self.numberOfTabs) {
        return;
    }
    
    //if previous selected index was the last tab ,keep the coming last one selected
    if (index == self.numberOfTabs-1) {
        newIndex = index -1;
    }
    
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:willRemoveTabAtIndex:)]) {
        [self.delegate BrowserTabView:self willRemoveTabAtIndex:index];
    }
    
	[self.tabTitlesArray removeObjectAtIndex:index];
    [self caculateFrame];
    self.selectedTabIndex = newIndex;
    
    if ([self.delegate respondsToSelector:@selector(BrowserTabView:didRemoveTabAtIndex:)]) {
        [self.delegate BrowserTabView:self didRemoveTabAtIndex:index];
    }
    
}
-(void)caculateFrame
{
    // caculate and save frame for each tab ,and it's title
    CGFloat tabWidth =TAB_WIDTH;
    float overlapWidth = OVERLAP_WIDTH;
    CGFloat height = self.bounds.size.height;
    CGFloat right = 0;
    
    [tabFramesArray removeAllObjects];
    [tabTitleFramesArray removeAllObjects];
    
    for (NSInteger tabIndex = 0; tabIndex <self.numberOfTabs; tabIndex++) {
        
        NSString *title = [self.tabTitlesArray objectAtIndex:tabIndex];
        const CGSize titleSize = [title sizeWithFont:titleFont];
        const CGFloat titleWidth = MIN(tabWidth - overlapWidth, titleSize.width);
        
        CGRect titleFrame = CGRectMake(rint(right  + (tabWidth  - titleWidth) / 2),
                                       rint((height - titleSize.height) / 2),
                                       titleWidth, titleSize.height);
        
        //tabFrame left 5 dp to show the background, and give a look that tab has bottom
        CGRect tabFrame = CGRectMake(right, 0, overlapWidth + tabWidth, height- TAB_FOOTER_HEIGHT);
        
        [tabFramesArray addObject:[NSValue valueWithCGRect:tabFrame]];
        [tabTitleFramesArray addObject:[NSValue valueWithCGRect:titleFrame]];
        
        right += tabWidth;
        
    }
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGFloat height = self.bounds.size.height;
	
    //left 5 dp to show the background, and give a look that tab has footer
	[tabViewBackImage drawInRect:CGRectMake(0, 0, self.frame.size.width, height - TAB_FOOTER_HEIGHT)];
    
	if (self.numberOfTabs > 0) {
        
        //tabs before the selected  are drawed in sequence from the first to the selected;
        for (NSInteger tabIndex = 0; tabIndex < selectedTabIndex; tabIndex++) {
            UIImage *image = nil;
            
            NSValue *tabFrameValue = [tabFramesArray objectAtIndex:tabIndex];
            CGRect tabFrame = [tabFrameValue CGRectValue];
            image = tabNormalImage;
            [normalTitleColor set];
            [image drawInRect:tabFrame];
            
            //draw  tab's title;
            NSString *title = [self.tabTitlesArray objectAtIndex:tabIndex];
            NSValue *titleFrameValue = [tabTitleFramesArray objectAtIndex:tabIndex];
            CGRect titleFrame = [titleFrameValue CGRectValue];
            
            [title drawAtPoint:titleFrame.origin
                      forWidth:titleFrame.size.width
                      withFont:titleFont
                 lineBreakMode:UILineBreakModeTailTruncation];
            
            
        }
        //tabs after the selected are drawed in sequence from the last to the selected ;
        for (NSInteger tabIndex = (self.numberOfTabs - 1); tabIndex >= selectedTabIndex; tabIndex--) {
            UIImage *image = nil;
            
            if (self.selectedTabIndex == tabIndex) {
                image = tabSelectedImage;
                [selectedTitleColor set];
            } else {
                image = tabNormalImage;
                [normalTitleColor set];
            }
            
            NSValue *tabFrameValue = [tabFramesArray objectAtIndex:tabIndex];
            CGRect tabFrame = [tabFrameValue CGRectValue];
            [image drawInRect:tabFrame];
            
            // draw the close image for the selected;
            if (self.selectedTabIndex == tabIndex && self.numberOfTabs>1){
                UIImage *tabClose = [UIImage imageNamed:@"tab_close.png"];
                [tabClose drawInRect:CGRectMake(tabFrame.origin.x+130, tabFrame.origin.y+12, 19, 18)];
                
            }
            
            //draw  tab's title;
            NSString *title = [self.tabTitlesArray objectAtIndex:tabIndex];
            NSValue *titleFrameValue = [tabTitleFramesArray objectAtIndex:tabIndex];
            CGRect titleFrame = [titleFrameValue CGRectValue];
            
            [title drawAtPoint:titleFrame.origin
                      forWidth:titleFrame.size.width
                      withFont:titleFont
                 lineBreakMode:UILineBreakModeTailTruncation];
            
        }
        
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	if (self.numberOfTabs > 0) {
        CGFloat overlapWidth = OVERLAP_WIDTH;
        CGFloat tabWidth = TAB_WIDTH;
        UITouch *touch = [touches anyObject];
        CGFloat x = [touch locationInView:self].x;
        if (x >= 5 && x <= (self.numberOfTabs * tabWidth - 5)) {
            
            NSInteger previousSelectedIndex = selectedTabIndex;
            NSInteger index = (x - 5 - overlapWidth / 2) / tabWidth;
            
            if (index >= self.numberOfTabs) {
                index = self.numberOfTabs - 1;
            } else if (index < 0) {
                index = 0;
            }
            
            self.selectedTabIndex = index;
            
            //reconigzer the close action and remove the tab,only the selected can been removed
            NSValue *tabFrameValue = [tabFramesArray objectAtIndex:index];
            CGRect tabFrame = [tabFrameValue CGRectValue];
            if (x - tabFrame.origin.x>130 && x <= tabFrame.origin.x +154 && (previousSelectedIndex == selectedTabIndex)) {
                [self removeTabAtIndex:index];
            }
            
        }
		
	}
}

@end
