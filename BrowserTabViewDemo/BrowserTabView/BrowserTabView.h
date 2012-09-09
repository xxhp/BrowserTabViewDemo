//
//  BrowserTabController.h
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

#import <UIKit/UIKit.h>
@class BrowserTabView;

@protocol BrowserTabViewDelegate<NSObject>

@optional
-(void)BrowserTabView:(BrowserTabView *)browserTabView didSelecedAtIndex:(NSUInteger)index;
-(void)BrowserTabView:(BrowserTabView *)browserTabView willRemoveTabAtIndex:(NSUInteger)index;
-(void)BrowserTabView:(BrowserTabView *)browserTabView didRemoveTabAtIndex:(NSUInteger)index;

@end

@interface BrowserTabView : UIView{
   
    //  image  for tab been selected
    UIImage *tabSelectedImage;
 
    //  image  for tab been normal state
    UIImage *tabNormalImage;
   
    // image for the tabview backgroud 
    UIImage *tabViewBackImage;
    
    NSUInteger numberOfTabs;
    
    NSInteger selectedTabIndex;
    
    //array for saving all the tab titles
    NSMutableArray *tabTitlesArray;
  
    //array for saving  frames of tab titles
    NSMutableArray *tabTitleFramesArray;
   
    //array for saving  frames of tabs
    NSMutableArray *tabFramesArray;
   
    //font of tab title
    UIFont *titleFont;
   
    //color for tab title when tab been normal state
    UIColor *normalTitleColor;
    
    //color for tab title when tab been selected
    UIColor *selectedTitleColor;
    
    id<BrowserTabViewDelegate> delegate;
    
}

@property(nonatomic, retain) UIImage *tabSelectedImage;
@property(nonatomic, retain) UIImage *tabNormalImage;
@property(nonatomic, retain) UIImage *tabViewBackImage;
@property(nonatomic, assign) NSUInteger numberOfTabs;
@property(nonatomic, assign) NSInteger selectedTabIndex;
@property(nonatomic, retain) NSMutableArray *tabTitlesArray;
@property(nonatomic, retain) NSMutableArray *tabTitleFramesArray;
@property(nonatomic, retain) NSMutableArray *tabFramesArray;
@property(nonatomic, retain) UIFont *titleFont;
@property(nonatomic, retain) UIColor *normalTitleColor;
@property(nonatomic, retain) UIColor *selectedTitleColor;
@property(nonatomic, assign) id<BrowserTabViewDelegate> delegate;

-(id)initWithTabTitles:(NSArray *)titles andDelegate:(id)adelegate;
- (void)addTabWithTitle:(NSString *)title;
-(void)caculateFrame;
@end
