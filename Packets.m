//
//  Packets.m
//  SocketTries
//
//  Created by Andrey Karaban on 31/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import "Packets.h"

NSString * const PacketsKeyData = @"data";
NSString * const PacketsKeyType = @"type";
NSString *const PaketsKeyAction = @"action";


@implementation Packets

- (id)initWithData:(id)data type:(PacketsType)type action:(PacketsAction)action
{
    self = [super init];
    if (self)
    {
        self.data = data;
        self.type = type;
        self.action = action;
    }
    return self;
}


#pragma mark -
#pragma mark NSCoding Protocol
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.data forKey:PacketsKeyData];
    [coder encodeInteger:self.type forKey:PacketsKeyType];
    [coder encodeInteger:self.action forKey:PaketsKeyAction];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        [self setData:[decoder decodeObjectForKey:PacketsKeyData]];
        [self setType:[decoder decodeIntegerForKey:PacketsKeyType]];
        [self setAction:[decoder decodeIntegerForKey:PaketsKeyAction]];
    }
    
    return self;
}



@end
