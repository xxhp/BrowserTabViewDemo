//
//  ViewController.h
//  BrowserTabViewDemo
//
//  Created by xiao haibo on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserTabView.h"

@interface ViewController : UIViewController<BrowserTabViewDelegate>
{
    BrowserTabView  *tabController;
}
@property (retain, nonatomic) IBOutlet UILabel *label;
@end
