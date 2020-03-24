# Intranet development notes

The Intranet lives under a new channel - separate from the NHSDigital public site, and we have a new set of `hst.page/hst.abstractpage/hst.template/hst.sitemap/ config in the cms console. Despite the fact that the NHSDigital site is public, and the Intranet site isn't, most of the assets and templates are shared between the 2 channels.

## Development approach

The approach for template building, styling and adding JavaScript is to reuse as much of the NHSDigital templates and stylesheets as possible, and only introduce new files if necessary. Having said that - you will have to be very careful when editing shared templates and macros, and styling because of that.

## Current state of the Intranet

Currently the new version of the Intranet is strongly WIP state, and it hasn't gone live yet.

The intranet has a static version of the home page built, which uses the new Intranet components, and as of today that's been merged into `master` branch. The static home page can be seen at [http://localhost:8080/site/intranet](http://localhost:8080/site/intranet)

We also have a task document, which is live and working with data from the CMS - that's been going through testing at the moment (DW-1225/DW-1226). The task documents are available at [http://localhost:8080/site/intranet/tasks/*](http://localhost:8080/site/intranet/tasks/*)

## Freemarker templates and macros

The Freemarker folder for Intranet is: `freemarker/intranet`

The layout structure of the Intranet pages is very similar to the public website layouts, but the Intranet has it's own set of layouts, header and footer.

In there, you'll find macros and layout files specific to Intranet.

## Stylesheets

The approach for the Intranet styling is this:
1. Take the NHSDigital styling
2. Add the Intranet specific styling on top of that

There are 2 main SASS files under the `scss` folder:
- nhsd-intranet.scss
- nhsd-intranet-print.scss

The source folder for the Intranet stylesheets is: `scss/intranet`

The Intranet specific components have `intra` prefix to help to avoid confusion

## Javascript

There is no Intranet specific JavaScript at this point, so the header and the footer scripts are loaded exactly the same way - using the same JS resources (from the same freemarker files) as on the public site. This needs to be revisited, and changed according to the business requirements (do we need tracking, do we need liveperson chats etc.), but these haven't been confirmed yet by the PO.


## Additional notes

The browser scope is IE11 and moder browsers, so the code should reflect that. I removed most of the old IE CSS, but if you see more feel free to remove them. Remember to triple check that the NHSDigital public site isn't affected by any of these changes!
