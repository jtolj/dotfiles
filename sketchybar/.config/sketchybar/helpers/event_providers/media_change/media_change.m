// media_change.m
#include "../sketchybar.h"
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
  float update_freq;

  NSLog(@"Starting up logger");
  if (argc < 3 || (sscanf(argv[2], "%f", &update_freq) != 1)) {
    printf("Usage: %s \"<event-name>\" \"<event_freq>\"\n", argv[0]);
    exit(1);
  }

  // Setup the event in sketchybar
  char event_message[512];
  snprintf(event_message, 512, "--add event '%s'", argv[1]);
  sketchybar(event_message);

  // Load the private MediaRemote framework once
  NSString *frameworkPath =
      @"/System/Library/PrivateFrameworks/MediaRemote.framework";
  NSBundle *mediaRemoteBundle = [NSBundle bundleWithPath:frameworkPath];
  if (![mediaRemoteBundle load]) {
    NSLog(@"Failed to load MediaRemote framework");
    return 1;
  }

  while (1) {
    @autoreleasepool {
      // Get the MRNowPlayingRequest class
      Class MRNowPlayingRequest = NSClassFromString(@"MRNowPlayingRequest");
      if (!MRNowPlayingRequest) {
        NSLog(@"MRNowPlayingRequest not available");
        goto sleep_iteration;
      }

      // Get the local now playing player's app name
      NSString *appName = @"";
      if ([MRNowPlayingRequest
              respondsToSelector:@selector(localNowPlayingPlayerPath)]) {
        id playerPath = [MRNowPlayingRequest
            performSelector:@selector(localNowPlayingPlayerPath)];
        if (playerPath && [playerPath respondsToSelector:@selector(client)]) {
          id client = [playerPath performSelector:@selector(client)];
          if (client && [client respondsToSelector:@selector(displayName)]) {
            appName = [client performSelector:@selector(displayName)];
          }
        }
      }

      NSLog(@"Got app name: %@", appName);
      // Get now playing info dictionary
      NSDictionary *nowPlayingInfo = nil;
      if ([MRNowPlayingRequest
              respondsToSelector:@selector(localNowPlayingItem)]) {
        id nowPlayingItem = [MRNowPlayingRequest
            performSelector:@selector(localNowPlayingItem)];
        if (nowPlayingItem &&
            [nowPlayingItem respondsToSelector:@selector(nowPlayingInfo)]) {
          nowPlayingInfo =
              [nowPlayingItem performSelector:@selector(nowPlayingInfo)];
        }
      }

      NSLog(@"Got now playing info: %@", nowPlayingInfo);

      // In case no information is available, send a "gone" event
      if (!nowPlayingInfo) {
        NSLog(@"Now playing info was null");
        sketchybar("--trigger 'media_change_custom' STATE=gone TITLE= ALBUM= "
                   "ARTIST= APP_NAME=");
        goto sleep_iteration;
      }

      // Extract the now playing values (using empty strings if missing)
      NSString *title =
          [nowPlayingInfo objectForKey:@"kMRMediaRemoteNowPlayingInfoTitle"]
              ?: @"";
      NSString *album =
          [nowPlayingInfo objectForKey:@"kMRMediaRemoteNowPlayingInfoAlbum"]
              ?: @"";
      NSString *artist =
          [nowPlayingInfo objectForKey:@"kMRMediaRemoteNowPlayingInfoArtist"]
              ?: @"";
      id playbackValue = [nowPlayingInfo
          objectForKey:@"kMRMediaRemoteNowPlayingInfoPlaybackRate"];

      // Determine playback state (1 means playing)
      NSString *state = @"stopped";
      if ([playbackValue isKindOfClass:[NSNumber class]]) {
        if ([(NSNumber *)playbackValue floatValue] == 1.0) {
          state = @"playing";
        }
      } else if ([playbackValue isKindOfClass:[NSString class]]) {
        if ([(NSString *)playbackValue isEqualToString:@"1"]) {
          state = @"playing";
        }
      }

      char messageBuffer[512] = {0};
      snprintf(messageBuffer, 512,
               "--trigger '%s' STATE='%s' TITLE='%s' ALBUM='%s' ARTIST='%s' "
               "APP_NAME='%s'",
               argv[1], [state UTF8String], [title UTF8String],
               [album UTF8String], [artist UTF8String], [appName UTF8String]);

      // Trigger the event
      sketchybar(messageBuffer);
    }

  sleep_iteration:
    // Run the run loop to allow MediaRemote XPC to respond
    [[NSRunLoop currentRunLoop]
           runMode:NSDefaultRunLoopMode
        beforeDate:[NSDate dateWithTimeIntervalSinceNow:update_freq]];
  }

  return 0;
}
