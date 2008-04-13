/*
Copyright (C) 2007 Stig Brautaset. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  Neither the name of the author nor the names of its contributors may be used
  to endorse or promote products derived from this software without specific
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "NSString+SBJSON.h"
#import "SBJSONScanner.h"


@implementation NSString (NSString_SBJSON)

- (id)JSONValue
{
    return [self JSONValueWithOptions:nil];
}

- (id)JSONValueWithOptions:(NSDictionary *)opts
{
    SBJSONScanner *scanner = [[[SBJSONScanner alloc] initWithString:self] autorelease];
    if (opts) {
        id opt = [opts objectForKey:@"MaxDepth"];
        if (opt)
            [scanner setMaxDepth:[opt intValue]];
    }

    id o;
    if ([scanner scanDictionary:&o] && [scanner isAtEnd])
        return o;
    if ([scanner scanArray:&o] && [scanner isAtEnd])
        return o;
    
    [NSException raise:@"enojson"
                format:@"Failed to parse '%@' as JSON", self];
}

- (id)JSONFragmentValue
{
    id o;

    SBJSONScanner *scanner = [[[SBJSONScanner alloc] initWithString:self] autorelease];
    if ([scanner scanValue:&o] && [scanner isAtEnd])
        return o;
    
    [NSException raise:@"enofragment"
                format:@"Failed to parse '%@' as a JSON fragment", self];
}

@end
