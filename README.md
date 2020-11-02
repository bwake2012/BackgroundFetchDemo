# BackgroundFetchDemo

This is a basic test program to demonstrate the new mode of background processing in iOS. 

It borrows from the article by Myrick Chow: [Swift iOS BackgroundTasks framework — Background App Refresh in 4 Steps](https://itnext.io/swift-ios-13-backgroundtasks-framework-background-app-refresh-in-4-steps-3da32e65bc3d).

It also borrows from (Modern Backgrounds Tasks in iOS 13)[https://www.andyibanez.com/posts/modern-background-tasks-ios13/] by Andy Ibanez, especially from the Pokémon retrieval.

It also borrows from the sample by Apple: [Refreshing and Maintaining Your App Using Background Tasks](https://developer.apple.com/documentation/backgroundtasks/refreshing_and_maintaining_your_app_using_background_tasks)

I have tried to separate management of the background task(s) from both AppDelegate and SceneDelegate. I have also tried to separate the actual task execution from its management.

It saves the results of its fetches in an array, which it writes to a JSON file. It displays the results in a UITableView.

I have not yet made this work. The BackgroundTasks framework looks simple enough, but there's something missing. It's interesting that Apple's (ColorFeed)[https://docs-assets.developer.apple.com/published/9decfbca71/RefreshingAndMaintainingYourAppUsingBackgroundTasks.zip] demo doesn't make any network calls. 

I did make old style background fetch work in my [TodayWidgetDemo](https://github.com/bwake2012/TodayWidgetDemo).
