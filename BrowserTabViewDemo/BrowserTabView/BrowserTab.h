//
//  BrowserTab.h
//  BrowserTabViewDemo
//
//  Created by  on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserTabView.h"
@class BrowserTabView;
@interface BrowserTab : UIView{
    //font of tab title
    UIFont *titleFont;
    
    //color for tab title when tab been normal state
    UIColor *normalTitleColor;
    
    //  image  for tab been selected
    UIImage *tabSelectedImage;
    
    //  image  for tab been normal state
    UIImage *tabNormalImage;
     
    NSString *reuseIdentifier;
    UIImageView *imageView;
    UIImageView *imageViewClose;
    
    NSInteger index;
    
    BOOL previousSelected ;
    BOOL selected;
    
    UIPanGestureRecognizer *panGuesture;
    BrowserTabView *delegate;
}
@property(nonatomic, retain) UIFont *titleFont;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, retain) UIImage *tabSelectedImage;
@property(nonatomic, retain) UIImage *tabNormalImage;
@property(nonatomic, retain) UIColor *normalTitleColor;
@property(nonatomic, retain) UIColor *selectedTitleColor;
@property(nonatomic, retain)  UIImageView *imageView;;
@property (nonatomic, readonly) UILabel *textLabel;
@property(nonatomic, retain)  UIImageView *imageViewClose;
@property (nonatomic, readonly) NSString *reuseIdentifier;
@property (nonatomic, assign) NSInteger index;
@property(nonatomic, assign) BrowserTabView * delegate;

-(id)initWithReuseIdentifier:(NSString *)aReuseIdentifier andDelegate:(id)aDelegate;
-(void)prepareForReuse;
@end
