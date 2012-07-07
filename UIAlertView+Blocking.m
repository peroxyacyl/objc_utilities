//
//  UIAlertView+Blocking.m
//
//  Created by Seki Inoue on 12/07/08.
//  Copyright (c) 2012年 peroxyacyl. All rights reserved.
//

#import "UIAlertView+Blocking.h"
#include <pthread.h>

@implementation UIAlertView (Blocking)

static pthread_once_t once = PTHREAD_ONCE_INIT;
static pthread_mutex_t _mutex;
static pthread_cond_t _cond;
static NSInteger _tmpButtonIndex = 0;

void uialertview_blocking_mutex_init() {
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
}

- (NSInteger)showBlocking {
    if ([NSThread isMainThread]) {
        [self show];
        return 0;
    }
    id orgDelegate = self.delegate;
    self.delegate = self;
    
    pthread_once(&once, uialertview_blocking_mutex_init);
    
    pthread_mutex_lock(&_mutex);
    [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
	pthread_cond_wait(&_cond, &_mutex);
	pthread_mutex_unlock(&_mutex);
    
    
    self.delegate = orgDelegate;
    return _tmpButtonIndex;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _tmpButtonIndex = buttonIndex;
    pthread_mutex_lock(&_mutex);
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}
@end
