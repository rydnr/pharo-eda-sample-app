# PharoEDA Sample App

An app based on [PharoEDA](https://github.com/osoco/pharo-eda "PharoEDA").

## Motivation

A sample application is useful for describing how to use PharoEDA, and also to try out bleeding-edge features when developing PharoEDA itself.

## Design

A simple domain consisting of:

- A conference
- Questions asked in a conference
- Questions liked in a conference

## Usage

First, load it with Metacello:

```smalltalk
Metacello new repository: 'github://osoco/pharo-eda-sample-app:main'; baseline: #PharoEDASampleApp; load
```

Then, run it with

```smalltalk
EDASAApplication run
```

## Credits

- Background of the Pharo image by <a href="https://pixabay.com/users/annapannaanna-7777967/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=3105514">Anna Gál</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=3105514">Pixabay</a>.
