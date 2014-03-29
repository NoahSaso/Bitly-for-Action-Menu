#import <Preferences/Preferences.h>

#define url(x) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:x]];

@interface BitlyforActionMenuListController: PSListController {
}
- (void)openLink;
- (void)openTwitter;
- (void)openDonate;
- (void)openWebsite;
@end

@implementation BitlyforActionMenuListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"BitlyforActionMenu" target:self] retain];
	}
	return _specifiers;
}
- (void)openLink {
	url(@"http://bitly.com/a/oauth_apps");
}
- (void)openTwitter {
	url(@"http://twitter.com/Sassoty");
}
- (void)openDonate {
	url(@"http://bit.ly/sassotypp");
}
- (void)openWebsite {
	url(@"http://sassoty.com");
}
@end

// vim:ft=objc
