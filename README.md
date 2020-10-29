# BackgroundFetchDemo

This is a basic text program to demonstrate the new mode of background processing in iOS. 

It borrows heavily from the article by Myrick Chow: [Swift iOS BackgroundTasks framework — Background App Refresh in 4 Steps](https://itnext.io/swift-ios-13-backgroundtasks-framework-background-app-refresh-in-4-steps-3da32e65bc3d).

It also borrows from the sample by Apple: [Refreshing and Maintaining Your App Using Background Tasks](https://developer.apple.com/documentation/backgroundtasks/refreshing_and_maintaining_your_app_using_background_tasks)

I have tried to separate management of the background task(s) from both AppDelegate and SceneDelegate. I have also tried to separate the actual task execution from its management.

I have not yet made this work. 

I did make old style background fetch work in my [TodayWidgetDemo](https://github.com/bwake2012/TodayWidgetDemo).
