# WasteNot - Food Supply Tracker

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

This app allows you to keep track of food you buy so that nothing gets wasted. Add items to your virtual pantry and the app will track their freshness, notifying you if something is about to expire.

### App Evaluation

- **Categories:** Lifestyle, Health & Fitness
- **Mobile:** This app is one users will need to check consistently as food is constantly being consumed and goes bad within weeks or days. Having push notifications when an item is about to expire is a useful feature that a website cannot provide. Potentially you may want a feature to take a picture of a food item instead of entering the item manually.
- **Story:** The value of the app is immediately obvious since most people in America have had the experience of having to throw out food since they didn't keep it properly. Furthermore, there is an angle of sustainability in reducing food waste.
- **Market:** The existing apps with this functionality are outdated and poorly-received. However, the app is useful for everyone. It does not have a niche market; instead it could be potentially adopted by every person in the country.
- **Habit:** The app concept is not addicting since it is more for record-keeping than gaining new information. However the user could end up using it multiple times per week if not every day from the nature of checking food.
- **Scope:** The basic version of this app is relatively simple, only requiring basic conditional logic and storing tableviews. Therefore it is reasonable to build with a basic understanding of Swift.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can see a list of foods
* User can add a food to their list
* User can see the expiration date(s) of their foods
* User can see when a food has expired
* User can remove a food from their list
* User can specify if food is stored in fridge, freezer or pantry, with expiration updating
* User can edit a food in their list
* User can sort their list by expiration, date added, and name

**Optional Nice-to-have Stories**

* User can create an account
* User can log in
* User can see a calendar of food expirations
* User is notified when food will expire soon via push
* User can take a picture of a food to add it to their list
* User can search for a food in their list

### 2. Screen Archetypes

**Stream**
* User can see a list of foods
* User can see the expiration date(s) of their foods
* User can see when a food has expired
* User can sort their list by expiration, date added, and name
* User can remove a food from their list
* User can search for a food in their list

**Creation**
* User can add a food to their list
* User can specify if food is stored in fridge, freezer or pantry, with expiration updating

**Detail**
* User can edit a food
* User can see the expiration date(s) of their foods
* User can see when a food has expired


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Feed
* Calendar

**Flow Navigation** (Screen to Screen)

- Stream Screen 
  - => Detail Screen when food is tapped
  - => New Food Screen when + button tapped
- Creation Screen 
  - => Home when back/cancel button pressed
- Detail Screen 
  - => Home when back button pressed
- Calendar
  - => None


## Wireframes


![resized_wireframe](https://hackmd.io/_uploads/SkI3z0SeA.jpg)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

[This section will be completed in Unit 9]

### Models

[Add table of models]

### Networking

- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]