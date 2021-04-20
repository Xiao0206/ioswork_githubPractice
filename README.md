# Checklist
This is a little project in "ios apprentice book 2" written by Matthijs Hollemans. I mainly followed his guidance and finished this project, besides, I also made some changes based on his code. This project improved my understanding about many important concepts and programming tricks in Objective-C such as delegate, protocol, vc stack etc..

## Function
0x01 Two-level lists\\
0x02 Local notifcation and date setting\\
0x03 Interesting icons \\

## Refinement
0x01 The original code is based on ios7 and some functions don't work well in iOS 9 or later version. For example, the default UIdate style in iOS 14.4 is not Wheel anymore, so we need to set its style to Wheel rather than calender manually.\\
0x02 In iOS 14, every time when an application wants to access some sensitive data such as messages,photos etc, the system would use an alert window to inform you the application's requirement and ask if you allow it to do so. That is why the local notification didn't work well in iOS14.4, I fixed this bug in this project.\\

