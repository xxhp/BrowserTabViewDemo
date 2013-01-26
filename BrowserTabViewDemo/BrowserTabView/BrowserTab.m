//
//
//  BrowserTab.m
//  BrowserTabViewDemo
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

#import "BrowserTab.h"

//define width of a tab ,here is the width of the image used to render tab;

#define TAB_WIDTH 154 
#define TAB_HEIGHT 38 

@interface BrowserTab () {
    NSString *__weak reuseIdentifier;
    BOOL previousSelected;
    UIPanGestureRecognizer *panGuesture;
}

@end

@implementation BrowserTab

@synthesize reuseIdentifier;

#pragma mark - init
- (id)initWithReuseIdentifier:(NSString *)aReuseIdentifier andDelegate:(id)aDelegate
{

    if (self = [super initWithFrame:CGRectZero]) {
        
        _delegate = aDelegate;
        reuseIdentifier = aReuseIdentifier;
        self.normalTitleColor = [UIColor whiteColor];
        self.selectedTitleColor = [UIColor blackColor];
        
        self.tabSelectedImage = [UIImage imageNamed:@"tab_selected.png"]; 
        self.tabNormalImage = [UIImage imageNamed:@"tab_normal.png"] ;
        
        
        
        self.titleFont = [UIFont systemFontOfSize:18];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.imageView.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = UITextAlignmentCenter;
        
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _imageViewClose = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.imageViewClose.backgroundColor = [UIColor clearColor];
        _imageViewClose.image = [UIImage imageNamed:@"tab_close.png"];
        _imageViewClose.hidden = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_imageViewClose];
        [self addSubview:_textLabel];
        
        [self setSelected:YES];
        panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:_delegate
                                                       action:@selector(handlePanGuesture:)];
        panGuesture.delegate = _delegate;
        [self addGestureRecognizer:panGuesture];
        
    }
    return self;
}

-(void)setSelected:(BOOL)isSelected
{
    _selected = isSelected;
    
    if (isSelected) {
        self.textLabel.textColor = _selectedTitleColor;
        _imageView.image = self.tabSelectedImage;
        if (self.delegate.numberOfTabs>1) {
            _imageViewClose.hidden = NO;
        }else{
            _imageViewClose.hidden = YES;
        }
        
    }else{
        self.textLabel.textColor = _normalTitleColor;
        _imageView.image = self.tabNormalImage;
        _imageViewClose.hidden = YES;
    }
}
-(void)prepareForReuse
{
    self.textLabel.text = nil;
    self.index = 0;
    self.delegate = nil;
    _selected = NO;    
}

-(void)layoutSubviews
{
    _title = self.textLabel.text;
    CGSize titleSize = [_title sizeWithFont:_titleFont];
    _imageView.frame = self.bounds;
    
    self.textLabel.frame = CGRectMake((self.bounds.size.width - titleSize.width)/2 , (self.bounds.size.height - titleSize.height)/2, titleSize.width,titleSize.height);
       
    _imageViewClose.frame =  CGRectMake(self.bounds.origin.x+115, self.bounds.origin.y+12, 19, 18);
    
    [super layoutSubviews];
}


#pragma mark -
#pragma mark - TouchEvent

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    previousSelected =  _selected;
    [self setSelected:YES];
    [self.delegate setSelectedTabIndex:self.index animated:NO];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	if (self.delegate.numberOfTabs > 0) {
        UITouch *touch = [touches anyObject];
        CGFloat x = [touch locationInView:self].x;
        if (x >120 && x <= TAB_WIDTH -8 && previousSelected) {
            [self.delegate removeTabAtIndex:self.index animated:YES];
        }
    }
}
@end
