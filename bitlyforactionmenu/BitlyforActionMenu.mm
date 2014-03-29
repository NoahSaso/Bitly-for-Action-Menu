#import <Preferences/Preferences.h>

@interface BitlyforActionMenuListController: PSListController {
}
- (void)openLink;
@end

@implementation BitlyforActionMenuListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"BitlyforActionMenu" target:self] retain];
	}
	return _specifiers;
}
- (void)openLink {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bitly.com/a/oauth_apps"]];
}
@end

// vim:ft=objc
