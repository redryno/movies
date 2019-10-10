# movies
This is a project that I create as an Objective-C code sample.

____________________

## Some points of interest.

I used a coordinator pattern to remove navigation from the view controllers. You can find these classes in the Coordinators folder of the project. On a small project like this, it's not really needed, but on larger apps like the one I just completed, it would have been very helpful.

I didn't use the main storyboard. Storyboards can be difficult to work with when multiple developers are  working on one project.

View controller views were built in sepparate classes. This happened to work out really well for the MovieDetailsViewController and the SearchDetailsViewController, because I was able to reuse the same view class for both.

On the SearchViewController, I used an NSInvocation to create a trampoline function. The API I'm using limits the number of calls I can make each day. To prevent uneccessary calls, I created a function that will coalesce the keystrokes.

All strings should be localized.

____________________

## More

I started this project in the evening on Oct 8th and stopped working on it on Oct 9th. So I ended working about 10 hours on this project. There is certainly a lot of UI work I would do if I had more time.

I used Cocoapods, Realm, and SDWebImage to speed up the build process.
