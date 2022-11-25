## Build tools & versions used
    
    - Xcode Version 14.0.1 (14A400)

## Steps to run the app
    
    - unzip the Employees.zip
    - in the root folder use Employees.xcodeproj open project in Xcode
    - Build and Run the project 

## What areas of the app did you focus on?

    ### Architecture

        - MVP design pattern used
        - Coordination pattern used
        - Added initial coordinator for injecting presenter
        - Code coverage is maximum using MVP pattern

    ### Features

        - portrait and landscape modes
        - handling different states: loading, success, empty, error
        - download image asyncronously 
        - support cancellation of image download when cell is not visible
        - supports in-disk caching of images
        


## What was the reason for your focus? What problems were you trying to solve?
    
    - structuring and organising code for better readability and maintainability. 
    - writing better code by separating out structure within code based on responsibility

## How long did you spend on this project?

    - 3 hours  

## Did you make any trade-offs for this project? What would you have done differently with more time?
    
    - I can split the ImageLoader class into different classes for storing cache and ongoing task
    - I can add employee detail screen where all details associated with employee can be shown with large image 


## What do you think is the weakest part of your project?

    ### Needs improvement in Image Loader

        - Can create a different classes for storing cache and ongoing task


## Did you copy any code or dependencies? Please make sure to attribute them here!
    
    - No, I have not used any third party code or dependencies

## Is there any other information you’d like us to know?

    - I feel like I have covered most of the important aspects already with this project, thank for the opportunity.
