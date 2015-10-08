# SplitViewSidebar

This little demo shows to make a *fixed width* (fully expanded or collapsed, no in-between) sidebar in an OS X app using NSSplitViewController.  Expanding or collapsing can be done programmatically (with a button) or by the user sliding the divider 10 points to the right or left.  Expanding or collapsing has the same nice animation in either case.

This version requires OS X 10.11 or greater, and is a little tricky because the window is in a nib.  According to the NSSplitViewController documentation, you *can* add views to split views "before calling super in -viewDidLoad", as this demo.  But it does not work in 10.10 because apparently there was a bug in 10.10: you could *not* add views at any time.

This restriction could be removed if you used a storyboard instead of a nib.  This is because, in Interface Builder, when editing a storyboard but not when editing a xib, NSSplitViewController, with NSSplitViewItems, are available in the Object Library.
