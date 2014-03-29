#import <ActionMenu/ActionMenu.h>
#import <CoreFoundation/CFUserNotification.h>

#define errEq(x,y) [x isEqualToString:y]
//#define alrt(x) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bitly for Action Menu" message:x delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];[alert release];
#define alrt(x) do { \
	NSDictionary *fields = @{(id)kCFUserNotificationAlertHeaderKey: @"Bitly for Action Menu", \
		(id)kCFUserNotificationAlertMessageKey: x, \
		(id)kCFUserNotificationDefaultButtonTitleKey : @"Ok"}; \
	CFUserNotificationRef notificationRef = CFUserNotificationCreate(kCFAllocatorDefault, 0, kCFUserNotificationNoteAlertLevel, NULL, (CFDictionaryRef)fields); \
	CFRelease(notificationRef); \
} \
while(0)

static NSString *settingsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.sassoty.bitlyforactionmenu.plist"];
static NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
static NSString *accessToken = prefs[@"accesstoken"];

@implementation UIResponder (BitlyForActionMenu)

- (void)doBitlyForActionMenu:(id)sender {
	// TODO: Implement Bitly for Action Menu Plugin
	if(!accessToken||[accessToken isEqualToString:@""]){
		alrt(@"Error! Make sure the Access Token is set in Settings");
	}else{
		[NSThread detachNewThreadSelector:@selector(getURL)
		toTarget:self withObject:nil];
	}
}

- (BOOL)canDoBitlyForActionMenu:(id)sender {
	if([self selectedTextualRepresentation]==nil||
		[[self selectedTextualRepresentation] isEqualToString:@""]) return NO;
	return YES;
}

- (void)getURL {

	NSString *escapedText = [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self selectedTextualRepresentation], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8) autorelease];
	if([escapedText rangeOfString:@"http" options:NSCaseInsensitiveSearch].location == NSNotFound)
		escapedText = [@"http://" stringByAppendingString:escapedText];

	NSString *urlString = [NSString stringWithFormat:@"https://api-ssl.bitly.com/v3/user/link_save?access_token=%@&longUrl=%@", accessToken, escapedText];

	NSURLRequest *request = [NSURLRequest
		requestWithURL:[NSURL URLWithString:urlString]];
    NSData *response = [NSURLConnection
    	sendSynchronousRequest:request
    	returningResponse:nil error:nil];
    NSString *resp = [[NSString alloc]
    	initWithData:response
    	encoding:NSUTF8StringEncoding];

    NSString *link = @"";
    @try {

    	NSString *lin1 = [[resp componentsSeparatedByString:@"\"link\": \""] objectAtIndex:1];
    	link = [[lin1 componentsSeparatedByString:@"\", \"aggregate_link\":"] objectAtIndex:0];

    } @catch (NSException *ex) {

    	NSString *error = [[[[resp componentsSeparatedByString:@"\"status_txt\": \""] objectAtIndex:1] componentsSeparatedByString:@"\"}"] objectAtIndex:0];
    	if(errEq(error, @"INVALID_URI")||
    		errEq(error, @"MISSING_ARG_LONGURL")){

    		alrt(@"Error! Invalid Link!");
    		return;

    	}else if(errEq(error, @"INVALID_ACCESS_TOKEN")||
    		errEq(error, @"MISSING_ARG_ACCESS_TOKEN")){

			alrt(@"Error! Make sure the Access Token is set correctly in Settings!");
			return;

    	}

    }

    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = link;

    alrt(@"Copied!");

}

+ (void)load {
	[[UIMenuController sharedMenuController]
		registerAction:@selector(doBitlyForActionMenu:)
		title:@"Bitly"
		canPerform:@selector(canDoBitlyForActionMenu:)];
}

@end

void reloadPrefs(){
	prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
	if(!prefs) prefs = [[NSMutableDictionary alloc] init];
	accessToken = prefs[@"accesstoken"];
	if(!accessToken) accessToken = @"";
}

%ctor {

	reloadPrefs();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
	    NULL,
	    (CFNotificationCallback)reloadPrefs,
	    CFSTR("com.sassoty.bitlyforactionmenu/preferencechanged"),
	    NULL,
	    CFNotificationSuspensionBehaviorDeliverImmediately);

}
