# weight_track_app

## Description
The weight track app, now written in flutter. This app can track what you lifted over time and give smart predictions on what your next weight should be.

This project has how been published to google play. Ever since there have been many more bugs discovered, so yeah use with caution...

<a _ngcontent-pfu-c7="" href="https://play.google.com/store/apps/details?id=com.amosgross.weight_track_app&amp;pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1"><img _ngcontent-pfu-c7="" alt="Get it on Google Play" src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" class="google_play_badge"></a>

## Models
- Organisation in:
    - DayOfSplit
    - Exercise
    - ExerciseSession
    - ExerciseInstance
- DayOfSplit:
    - Is representative of a day (like Push, Pull or Legs) in your split
    - Contains exercises you would do on that day (and ways to remove and add them, in the case that you use a new training plan)
- Exercise
    - Is representative of an Exercise you would do (like Squats or Bench)
    - Stores all Instances of you doing that exercise (and ways to edit that)
- ExerciseSession
    - Is representative of the portion of a workout where you would do that exercise
    - Idea is to shield off poor sets, and only take best set of a workout into account for future calculations
- ExerciseInstance
    - Is representative of one time you did a certain exercise
    - Contains reps and weights, that need to be stored

## Routing
- Navigation in the app uses the Navigator class (from flutter)
- Is implemented in ``pages.main_content_pane.dart`` as a Navigatior under the main Scaffold containing the BottomNavigationBar
- To use Navigation in the app, visit the ``routes.route_constants.dart`` file to add new routes, or to find the navigation key (or keys, depending later implementation)

