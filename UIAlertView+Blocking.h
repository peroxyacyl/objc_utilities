//
//  UIAlertView+Blocking.h
//
//  Created by Seki Inoue on 12/07/08.
//  Copyright (c) 2012年 peroxyacyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Blocking)<UIAlertViewDelegate>
/**
 
 - (NSInteger)showBlocking;
 
 Show alert and block thread unless user tap the buttons.
 If called on main thread, just "-show" will be called.
 
 Retuens button index selected.
 */

- (NSInteger)showBlocking;
@end
