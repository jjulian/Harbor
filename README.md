# Harbor

## Getting students on the same page

An iPad app that loads sets of urls as pushed by the teacher.

### What problems does it solve?
* It saves time: students to not need to waste classroom time typing urls
* It avoids distractions: no url bar, so students are not tempted to browse the internet at large
* With some extension, it can allow teachers to "push" information directly to the student's iPad
* Teachers can build sets of urls ahead of time, and direct students to them at will *"Open the Harbor app and read through the three pages I've shared. In ten minutes, we'll look at three more."*

### FIRST PLACE WINNER at Education Hack Day, November 12-13 2011
(Project name: "Digital Harbor")

* [Original idea](http://educationhackday.uservoice.com/forums/118005-educator-s-wish-list/suggestions/2369073-teacher-guided-web-browsing), inspiration, leadership: Andrew Coy
* Teacher Experience (web site), CloudMine integration: Donald Abrams
* Student Experience (iPad App): Jonathan Julian
* Design, icons, "the pitch", MICA POV, rap music: [Ronin Wood](http://roninwoodalloneworddotcom.biz)

![screenshot](http://dl.dropbox.com/u/2460931/harbor-screenshot.png)

### Development
This is my first iOS app, so forgive the hackiness and general noob coding style. When run on the device, the urls are fetched from [CloudMine](https://cloudmine.me/), which is where they are pushed by the teacher web app. When run in the Simulator, localhost is used as the backend. Run the small Sinatra server (ruby) to simulate the api (devsupport/fake_cloudmine.rb). See BrowserViewController#refresh.