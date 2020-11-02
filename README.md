# BackgroundFetchDemo

This is a basic test program to demonstrate the new mode of background processing in iOS. 

I read a number of articles about the new framework:

* Myrick Chow: [Swift iOS BackgroundTasks framework — Background App Refresh in 4 Steps](https://itnext.io/swift-ios-13-backgroundtasks-framework-background-app-refresh-in-4-steps-3da32e65bc3d).

* Andy Ibanez: (Modern Backgrounds Tasks in iOS 13)[https://www.andyibanez.com/posts/modern-background-tasks-ios13/], especially from the Pokémon retrieval.

* Yuvrajsinh Vaghela: (How to Update App Content With Background Tasks Using The Task Scheduler In iOS 13?)[https://dzone.com/articles/how-to-update-app-content-with-background-tasks-us]

* Hitesh Trivedi: (How To Use BackgroundTasks Framework To Keep your iOS App Content Up To Date?)[https://www.spaceotechnologies.com/ios-background-task-framework-app-update/]

It also borrows from the sample by Apple: [Refreshing and Maintaining Your App Using Background Tasks](https://developer.apple.com/documentation/backgroundtasks/refreshing_and_maintaining_your_app_using_background_tasks)

I have tried to separate management of the background task(s) from both AppDelegate and SceneDelegate. I have also tried to separate the actual task execution from its management.

It saves the results of its fetches in an array, which it writes to a JSON file. It displays the array of results in a UITableView. It includes a way to manually fetch a random Pokémon. It includes pull-to-refresh to update the display, just in case.

I have not yet made this work. The BackgroundTasks framework looks simple enough, but there's something missing. It's interesting that Apple's (ColorFeed)[https://docs-assets.developer.apple.com/published/9decfbca71/RefreshingAndMaintainingYourAppUsingBackgroundTasks.zip] demo doesn't make any network calls. Andy Ibanez's sample doesn't appear to fetch Pokémon either.

I did make old style background fetch work in my [TodayWidgetDemo](https://github.com/bwake2012/TodayWidgetDemo).

![BackgroundFetchDemo screen shot](https://octodex.github.com/images/yaktocat.png)
