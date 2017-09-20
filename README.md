#Instructions:

In order to run the project:

1) Clone the repository and open the Xcode project.
2) Connect a iOS device with a front facing camera running iOS 10.3 or later
3) Test

##Implementation:

To complete this task I used a library called SwiftyCam to handle capturing pictures of the user through the front facing camera. After the 10 pictures are taken over a interval of 5 seconds a password key chain is stored securely using an Apple provided struct called KeychainPasswordItem. This key chain is persisted to the device and can be checked against to ensure that credentials provided by a future user trying to access the stored pictures matches. 

After this key chain is stored a segue will be triggered to show the captured pictures in a TableViewController. Navigate back to the previous view and you will see a button in the top left that says "Login for Pictures". The password and user name used to secure the pictures are constants in the ViewController.swift file on lines 26 and 27. Since they were not changed since you took the pictures you will still be able to access the TableViewController.

In order for you to test that the credentials are verified correctly go into ViewController.swift and change the password constant on line 27. 

Rerun the app and tap "Login for Pictures". Since the password constant was changed it will not match the credentials stored in the key chain. If the password constant was not changed access will be granted to the next view controller, which contains a table view to display the captured pictures. 

##Further Considerations:

Unfortunately once I started the challenge I quickly realized that I upgraded my iPhone to iOS 11 on 9/19 when it was released and I had not updated my Xcode to Xcode 9 so I was unable to test on my physical device without taking the time to upgrade :o

I lost some time correcting this issue and as a result I was not able to finish persisting the photos to the physical device after they were taken. So they only live in memory until you restart the application then they will be lost.

However, time permitting I was planning on using CoreData to store the UIImages captured from SwiftyCam locally to the device. After they were stored I would only allow them to be read back into memory once the identity of the user was verified using my implementation of the secure key chain. 

Thank you for the challenge!! I found it refreshing in comparison to other on line pre interview screening techniques such as HackerRank. 