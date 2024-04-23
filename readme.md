# WasteNot - Food Supply Tracker

### Current State of App

<div>
    <a href="https://www.loom.com/share/786370fcb0ec4d8187042de906953ec2">
      <p>View on Loom</p>
    </a>
    <a href="https://www.loom.com/share/786370fcb0ec4d8187042de906953ec2">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/786370fcb0ec4d8187042de906953ec2-with-play.gif">
    </a>
  </div>

### Sprint 1 Version
<div>
    <a href="https://www.loom.com/share/6c0934c328c8487db0e09e8c3d042a63">
      <p>View on Loom</p>
    </a>
    <a href="https://www.loom.com/share/6c0934c328c8487db0e09e8c3d042a63">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6c0934c328c8487db0e09e8c3d042a63-with-play.gif">
    </a>
  </div>

## Table of Contents

1. [Sprints](#Sprints)
2. [Overview](#Overview)
3. [Product Spec](#Product-Spec)
4. [Wireframes](#Wireframes)
5. [Schema](#Schema)

## Sprints

1. Brainstorm ideas, set up project with empty screens and research food expiration
   - [x] Created initial empty screens + viewcontrollers
   - [x] Created tableview
   - [x] Found data source for food expiration calculation
   - Challenges faced: Implementing navigation and tab controllers, then trying to rename view controller
2. Scrape food expiration data from web and implement Food models
   - [x] Created form to compose new food
   - [x] Added tableview logic
   - [x] Scraped expiration data from web
   - [x] Implemented Food and Food Type models
   - [x] Implemented search bar in food type selection screen
   - [x] Implemented expired status feature and dynamic section headers
   - [x] Implemented deleting items
   - Challenges faced: Passing data between view controllers using delegates was new and I didn't understand it at first. I also had to change up the models a couple times to get what I wanted. The logic was quite confusing.
3. Add filtering by storage and calendar view

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

![wireframe](https://github.com/alexdivadi/wastenot/assets/26191218/93fb55a8-87cc-45c5-b4a6-cf9fa897a900)

### Digital Wireframes & Mockups

<img width="607" alt="figma-wireframe" src="https://github.com/alexdivadi/wastenot/assets/26191218/28310a16-cc75-4f34-9ec5-6f67ac88301d">

### Interactive Prototype

<div>
    <a href="https://www.loom.com/share/e254fb689470467ab708d62b76b65df5">
      <p>Prototype Video</p>
    </a>
    <a href="https://www.loom.com/share/e254fb689470467ab708d62b76b65df5">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/e254fb689470467ab708d62b76b65df5-with-play.gif">
    </a>
  </div>

## Schema 


### Models

[Add table of models]
