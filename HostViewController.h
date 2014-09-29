//
//  HostViewController.h
//  SocketTries
//
//  Created by Andrey Karaban on 29/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGDAsyncSocket;

@protocol HostViewControllerDelegate;


@interface HostViewController : UIViewController <NSNetServiceDelegate, GCDAsyncSocketDelegate, HostViewControllerDelegate>

@property (weak, nonatomic) id <HostViewControllerDelegate>delegate;

//The service property represents the network service that we will be publishing using Bonjour
@property (strong, nonatomic) NSNetService *service;

//The socket property is of type GCDAsyncSocket and provides an interface for interacting with the socket that we will be using to listen for incoming connections.
@property (strong, nonatomic) GCDAsyncSocket *socket;

@end

@protocol HostViewControllerDelegate

@optional

- (void)controller:(HostViewController *)controller didHostOnSocket:(GCDAsyncSocket *)socket;
- (void)controllerDidCancelHosting:(HostViewController *)controller;
@required
- (void)startBroadcast;
@end