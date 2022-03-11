/*
 Navicat Premium Data Transfer

 Source Server         : cborm-postgresql
 Source Server Type    : PostgreSQL
 Source Server Version : 120006
 Source Host           : localhost:5432
 Source Catalog        : coolblog
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 120006
 File Encoding         : 65001

 Date: 10/03/2022 16:29:48
*/


-- ----------------------------
-- Table structure for blogEntries
-- ----------------------------
DROP TABLE IF EXISTS "public"."blogEntries";
CREATE TABLE "public"."blogEntries" (
  "blogEntriesID" int4 NOT NULL,
  "blogEntriesLink" text COLLATE "pg_catalog"."default" NOT NULL,
  "blogEntriesTitle" text COLLATE "pg_catalog"."default" NOT NULL,
  "blogEntriesDescription" text COLLATE "pg_catalog"."default" NOT NULL,
  "blogEntriesDatePosted" timestamp(6) NOT NULL,
  "blogEntriesdateUpdated" timestamp(6) NOT NULL,
  "blogEntriesIsActive" varchar(1) COLLATE "pg_catalog"."default" NOT NULL,
  "blogsID" int4
)
;
ALTER TABLE "public"."blogEntries" OWNER TO "cborm";

-- ----------------------------
-- Records of blogEntries
-- ----------------------------
BEGIN;
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (1, 'http://blog.coldbox.org/post.cfm/coldbox-wiki-docs-skins-shared', 'ColdBox Wiki Docs Skins Shared', 'Since we love collaboration and giving back to the community, we have just opened our Wiki Docs Skins github repository so you can check out how we build out our wiki docs skins for CodexWiki and hopefully you guys can send us your skins and we can use them on the wiki docs site :)', '2011-04-06 11:13:52', '2011-04-06 11:13:52', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (2, 'http://blog.coldbox.org/post.cfm/new-coldbox-wiki-docs', 'New ColdBox Wiki Docs', 'We have been wanting to update all our sites for a long time and the docs where first. Yesterday we updated our codex skins for the coldbox wiki docs and also started our documentation revisions and updates. You will see that it is now much much better organized and our new quick index feature enables you to get to content even faster. Hopefully in the coming weeks we will have all our documentation updated and running. Thank you for your support and feedback.', '2011-04-06 10:57:17', '2011-04-06 10:57:17', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (3, 'http://blog.coldbox.org/post.cfm/modules-contest-ends-this-friday', 'Modules Contest Ends This Friday', 'Just a quick reminder that our Modules Contest ends this Friday! So get to it, build some apps! Modules Contest URL: http://blog.coldbox.org/post.cfm/coldbox-modules-contest-extended', '2011-04-04 11:22:19', '2011-04-04 11:22:19', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (4, 'http://blog.coldbox.org/post.cfm/coldbox-connection-recording-coldbox-3-0-0', 'ColdBox Connection Recording: ColdBox 3.0.0', 'Thanks for attending our 3rd ColdBox Connection webinar today!&nbsp; This  webinar focused on ColdBox 3.0.0 release and goodies.&nbsp; Here is the recording for the show!', '2011-03-30 15:42:16', '2011-03-30 15:42:16', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (5, 'http://blog.coldbox.org/post.cfm/coldbox-platform-3-0-0-released', 'ColdBox Platform 3.0.0 Released', '
  
  
I am so happy to finally announce ColdBox Platform 3.0.0 today on March 3.0, 2011. It has been over a year of research, testing, development, coding, long long nights, 1 beautiful baby girl, lots of headaches, lots of smiles, inspiration, blessings, new contributors, new team members, new company, new hopes, and ambitions. Overall, what an incredible year for ColdFusion and ColdBox development. I can finally say that this release has been the most ambitious release and project I have tackled in my entire professional life. I am so happy of the results and its incredible community response and involvement. So thank you so much Team ColdBox and all the community for the support and long hours of testing, ideas and development.
ColdBox 3 has been on a journey of 6 defined milestones and 2 release candidates in a spawn of over a year of development. Our vision was revamping the engine into discrete and isolated parts:

Core
LogBox : Enterprise Logging Library
WireBox : Enterprise Dependency Injection and AOP framework
CacheBox : Enterprise Caching Engine &amp; Cache Aggregator
MockBox : Mocking/Stubbing Framework

All of these parts are now standalone and can be used with any ColdFusion application or ColdFusion framework. We believe we build great tools and would like everybody to have access to them even though they might not even use ColdBox MVC. Apart from the incredible amount of enhancements, we also ventured into several incredible new features:

What''s New
ColdBox Modules : Bringing Modular Architecture to ANY ColdBox application
Programmatic configuration, no more XML
Incredible caching enhancements and integrations
Extensible and enterprise dependency injection
Aspect oriented programming
Integration testing, mocking, stubbing and incredible amount of tools for testing and verification
Customizable Flash RAM and future web flows
ColdFusion ORM and Hibernate Services
RESTful web services enhancement and easy creations
Tons more

 
The What''s New page can say it all! An incredible more than 700 issue tickets closed and ColdBox 3.1 is already in full planning phases. So apart from all this work culminating, we can also say we have transitioned into a complete professional open source software offering an incredible amount of professional services and backup to any enterprise or company running ColdBox or any of our supporting products (Relax, CodexWiki, ForumMan, DataBoss, Messaging, ...):

Support &amp; Mentoring Plans
Architecture &amp; Design
Over 4 professional training courses
Server Setup, Tuning and Optimizations
Custom Consulting and', '2011-03-29 23:30:18', '2011-03-29 23:30:18', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (6, 'http://blog.coldbox.org/post.cfm/cachebox-1-2-released', 'CacheBox 1.2 Released', '
  
  In the spirit of more releases, here is: CacheBox 1.2.0.  CacheBox is an enterprise caching engine, aggregator and API for  ColdFusion applications.  It is part of the ColdBox 3.0.0 Platform but  it can also function on its own as a standalone framework and use it in any ColdFusion application and in any ColdFusion framework. 
The milestone page for this release can be found in our Assembla Code Tracker. Here is a synopsis of the tickets closed:
  

 

1179	 new cachebox store: BlackholeStore used for optimization and testing
1180	 cf store does not use createTimeSpan to create minute timespans for puts
1181	 railo store does not use createTimeSpan to create minute timespans for puts
1182	 updates to make it coldbox 3.0 compatible
1192	 store locking mechanisms updated to improve locking and concurrency

So have fun playing with our new CacheBox release:

Download
Cheatsheet
Source Code
Documentation

 ', '2011-03-29 23:26:09', '2011-03-29 23:26:09', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (7, 'http://blog.coldbox.org/post.cfm/wirebox-1-1-1-released', 'WireBox 1.1.1 Released!', 'I am happy to announce WireBox 1.1.1 to the ColdFusion community. This release sports 3 critical fixes that will make your WireBox injectors run smoother and happier, especially for those doing java integration, this will help you some more.


Download
Cheatsheet
Source Code
Documentation
Our primer: Getting Jiggy Wit It!

  Issues Fixed

1184 changed way providers accessed scoped injectors via scope registration structure instead of injector references to avoid memory leaks
    1188 updated the java builder to ignore empty init arguments.
    1189 updated the java builder to do noInit() as it was ignoring it
', '2011-03-29 23:20:32', '2011-03-29 23:20:32', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (8, 'http://blog.coldbox.org/post.cfm/module-lifecycles-explained', 'Module Lifecycles Explained', 'In this short entry I just wanted to lay out a few new diagrams that explain the lifecycle of ColdBox modules.  As always, all our documentation reflects these changes as well.  This might help some of you developers getting ready to win that ColdBox Modules contest and get some cash and beer!

Module Service
The beauty of ColdBox Modules is that you have an internal module  service that you can tap to in order to dynamically interact with the  ColdBox Modules.  This service is available by talking to the main  ColdBox controller and calling its getModuleService() method: 
// get module service from handlers, plugins, layouts, interceptors or views.
ms = controller.getModuleService();

// You can also inject it via our autowire DSL
property name="moduleService" inject="coldbox:moduleService";

  
Module Lifecycle

   

However, before we start reviewing the module service methods let''s  review how modules get loaded in a ColdBox application.  Below is a  simple bullet point of what happens in your application when it starts  up and you can also look at the diagram above: 

ColdBox main application and configuration loads 
ColdBox Cache, Logging and WireBox are created 
Module Service calls on registerAllModules() to read all the  modules in the modules locations (with include/excludes) and start  registering their configurations one by one.  If the module had parent  settings, interception points, datasoures or webservices, these are  registered here. 
All main application interceptors are loaded and configured 
ColdBox is marked as initialized 
Module service calls on activateAllModules() so it begins  activating only the registered modules one by one.  This registers the  module''s SES URL Mappings, model objects, etc 
afterConfigurationLoad interceptors are fired 
ColdBox aspects such as i18n, javaloader, ColdSpring/LightWire factories are loaded 
afterAspectsLoad interceptors are fired 

The most common methods that you can use to control the modules in your application are the following: 

reloadAll() : Reload all modules in the application. This  clears out all module settings, re-registers from disk, re-configures  them and activates them 
reload(module) : Target a module reload by name 
unloadAll()  : Unload all modules 
unload(module) : Target a module unload by name 
registerAllModules() : Registers all module configurations 
registerModule(module) : Target a module configuration registration 
activateAllModules() : Activate all registered modules 
activateModule(module) : Target activate a module that has been registered already 
getLoadedModules() : Get an array of loaded module names 
rebuildModuleRegistry() : Rescan all the module lcoations for newly installed modules and rebuild the registry so these modules can  be registered and activated. 
registerAndActivateModule(module) : Registe', '2011-03-29 11:42:49', '2011-03-29 11:42:49', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (9, 'http://blog.coldbox.org/post.cfm/coldbox-connection-show-wednesday', 'ColdBox Connection Show Wednesday', 'Just a reminder that this March 3.0.0, 2011 we will be holding a special ColdBox Open Forum Connection at 9 AM PST.&nbsp; You can find more information below:Location:&nbsp; http://experts.adobeconnect.com/coldbox-connection/ColdBox Connection Shows: http://www.coldbox.org/media/connectionWatch out!! Something is coming!!', '2011-03-28 20:59:29', '2011-03-28 20:59:29', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (10, 'http://blog.coldbox.org/post.cfm/coldbox-modules-contest-extended', 'ColdBox Modules Contest Extended', 'We are extending our Modules Contest to allow for more time for entries to trickle in and of course to leverage ColdBox 3 coming this week.
Deadline: Module entries must be submitted by March 29th EXTENDED: April 8th, 2011 no later than 12PM PST to contests@ortussolutions.com
Winners Announced on March 30th EXTENDED: April 14th, 2011 The ColdBox Connection show at 9AM PST
ColdBox 3.0 Modules ContestCreate a ColdBox 3.0.0 module that is a fully functional application that can be portable for any ColdBox 3.0 application.  Here are some guidelines the ColdBox team will be evaluating the module on

Download ColdBox

The code must reside on either github or a public repository so it is publicly accessible

The user must create a forgebox entry and submit the module code to it: http://coldbox.org/forgebox

The more internal libraries it uses the more points it gets: LogBox, MockBox, WireBox, CacheBox

The module should do something productive, no say hello modules accepted

Best practices on MVC separation of concerns

Portability

Documentation (You had that one coming!!) as it might need DB setup or DSN setup

Be creative!

Make sure it works!


1st Prize

An Adobe ColdFusion 9 Standard License

$100 Amazon Gift Card

Six pack of "BrewFather" beer


2nd Prize

A ColdBox Book

A ColdBox T-Shirt

$25 Amazon Gift Card

Six pack of "BrewFather" beer
', '2011-03-27 20:29:07', '2011-03-27 20:29:07', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (11, 'http://blog.coldbox.org/post.cfm/coldbox-3-release-training-special-discounts', 'ColdBox 3 Release Training Special Discounts', '
				We are currently holding a special promotion that starts today March 27, 2011 until April 3rd, 2011
				 at 3:00 PM PST.  Take advantage of this insane $300 off any training of your choice in honor 
				 of our ColdBox 3.0.0 release this week.  Just use our discount code 
				viva3 in our training registration pages or follow our links below and get this discount.  
				Hurry as the code expires on April 3rd, 2011 at 3PM PST.
				
				
California Ontario/Los Angeles Training - April 27 to May 1, 2011

Discount Link: http://coldbox.eventbrite.com/?discount=viva3 
CBOX-101 ColdBox Core on April 27 - April 29, 2011
CBOX-203 ColdBox Modules on April 30 - May 1, 2011

Pre-CFObjective Minneapolis Training - May 10-11, 2011

Discount Link: http://coldbox-cfobjective.eventbrite.com/?discount=viva3 
CBOX-100 ColdBox Core on May 10-11, 2011
CBOX-202 WireBox Dependency Injection on May 10-11, 2011

Houston, Texas Training - April 27 to May 1, 2011

Discount Link: http://coldbox-texas.eventbrite.com/?discount=viva3 
CBOX-101 ColdBox Core on July 6-8, 2011
CBOX-203 ColdBox Modules on July 7-8, 2011
', '2011-03-27 20:18:44', '2011-03-27 20:18:44', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (12, 'http://blog.coldbox.org/post.cfm/coldbox-connection-recordings-page', 'ColdBox Connection Recordings Page', 'We just created our new recordings page for the ColdBox Connection today, so you can get in one location all of the recordings.&nbsp; Hopefully in the near future we will expand it with tags and search.', '2011-03-25 11:36:08', '2011-03-25 11:36:08', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (13, 'http://blog.coldbox.org/post.cfm/coldbox-connection-recording-coldbox-modules', 'ColdBox Connection Recording: ColdBox Modules', 'Thanks for attending our 2nd ColdBox Connection webinar today!&nbsp; This webinar focused on ColdBox modules, modularity and architecture.&nbsp; Thanks go to Curt Gratz for presenting such excellent topic.&nbsp; Here is the recording for the show and also please note that we will have another show March 3.0!', '2011-03-24 11:41:53', '2011-03-24 11:41:53', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (14, 'http://blog.coldbox.org/post.cfm/coldbox-connection-thursday-modules', 'ColdBox Connection Thursday: Modules', 'Just a reminder that our ColdBox Connection Show continues this Thursday at 9 AM PST! Curt Gratz will be presenting on ColdBox Modules and of course we will all be there for questions and help. See you there!Location: http://experts.adobeconnect.com/coldbox-connection/Our full calendar of events can be found here: http://coldbox.org/about/eventscalendar', '2011-03-22 08:48:10', '2011-03-22 08:48:10', '1', 1);
INSERT INTO "public"."blogEntries" ("blogEntriesID", "blogEntriesLink", "blogEntriesTitle", "blogEntriesDescription", "blogEntriesDatePosted", "blogEntriesdateUpdated", "blogEntriesIsActive", "blogsID") VALUES (15, 'http://blog.coldbox.org/post.cfm/coldbox-relax-v1-4-released', 'ColdBox Relax v1.4 released!', 'Here is a cool new update for ColdBox Relax - RESTful Tools For Lazy Experts!&nbsp; This update fixes a few issues reported and also enhances the Relaxer console and updates its ability to support definitions for multiple tiers and much more. So download it now!
Here are the closed issues for this release:

  #14 api_logs direct usage reference removed fixes
      #15 basic http authentication added to relaxer console so you can easily hit resources that require basic auth
      #10 entry points can now be a structure of name value pairs for multiple tiers
   #16 new browser results tab window to show how the results are rendered by a browser
      #17 addition http proxy as advanced settings to relaxer console so you can proxy your relaxed requests
      #11 Route Auto Generation - Method security fixes so implicit structures are generated alongside json structures

Here is also a nice screencast showcasing version 1.4 capabilities:
&nbsp;



  
What is Relax? ColdBox Relax is a set of RESTful tools for lazy experts.   We pride ourselves in helping developers work smarter and of course  document more in less time by providing them the necessary tools to  automagically document and test.  ColdBox Relax is a way to describe  RESTful web services, test RESTful web services, monitor RESTful web  services and document RESTful web services. The following introductory video will explain it better than words!
&nbsp;



So what are you waiting for? Get Relax Now!

  Source Code
  Download
  Documentation

  
', '2011-03-21 16:51:09', '2011-03-21 16:51:09', '1', 1);
COMMIT;

-- ----------------------------
-- Table structure for blogs
-- ----------------------------
DROP TABLE IF EXISTS "public"."blogs";
CREATE TABLE "public"."blogs" (
  "blogsID" int4 NOT NULL,
  "blogsURL" text COLLATE "pg_catalog"."default" NOT NULL,
  "blogsWebsiteurl" text COLLATE "pg_catalog"."default" NOT NULL,
  "blogslanguage" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "blogsTitle" text COLLATE "pg_catalog"."default" NOT NULL,
  "blogsDescription" text COLLATE "pg_catalog"."default" NOT NULL,
  "blogsdateBuilt" timestamp(6) NOT NULL,
  "blogsdateSumitted" timestamp(6) NOT NULL,
  "blogsIsActive" varchar(1) COLLATE "pg_catalog"."default" NOT NULL,
  "blogsAuthorname" varchar(200) COLLATE "pg_catalog"."default",
  "blogsauthorEmail" varchar(200) COLLATE "pg_catalog"."default",
  "blogsauthorURL" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."blogs" OWNER TO "cborm";

-- ----------------------------
-- Records of blogs
-- ----------------------------
BEGIN;
INSERT INTO "public"."blogs" ("blogsID", "blogsURL", "blogsWebsiteurl", "blogslanguage", "blogsTitle", "blogsDescription", "blogsdateBuilt", "blogsdateSumitted", "blogsIsActive", "blogsAuthorname", "blogsauthorEmail", "blogsauthorURL") VALUES (1, 'http://blog.coldbox.org/feeds/rss.cfm', 'http://blog.coldbox.org/', '', 'ColdBox Platform', 'The official ColdBox Blog', '2011-04-08 15:19:13', '2011-04-08 15:19:13', '1', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for cacheBox
-- ----------------------------
DROP TABLE IF EXISTS "public"."cacheBox";
CREATE TABLE "public"."cacheBox" (
  "id" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "objectKey" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "objectValue" text COLLATE "pg_catalog"."default" NOT NULL,
  "hits" int4 NOT NULL,
  "timeout" int4 NOT NULL,
  "lastAccessTimeout" int4 NOT NULL,
  "created" timestamp(6) NOT NULL,
  "lastAccessed" timestamp(6) NOT NULL,
  "isExpired" int2 NOT NULL,
  "isSimple" int2 NOT NULL
)
;
ALTER TABLE "public"."cacheBox" OWNER TO "cborm";

-- ----------------------------
-- Records of cacheBox
-- ----------------------------
BEGIN;
INSERT INTO "public"."cacheBox" ("id", "objectKey", "objectValue", "hits", "timeout", "lastAccessTimeout", "created", "lastAccessed", "isExpired", "isSimple") VALUES ('DF658A103F07DC012AB905014C32D4C7', 'myKey', 'hello', 1, 0, 0, '2016-02-25 16:34:00', '2016-02-25 16:34:00', 1, 1);
COMMIT;

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS "public"."categories";
CREATE TABLE "public"."categories" (
  "category_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "category" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "modifydate" timestamp(6) NOT NULL,
  "testValue" varchar(100) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."categories" OWNER TO "cborm";

-- ----------------------------
-- Records of categories
-- ----------------------------
BEGIN;
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('3A2C516C-41CE-41D3-A9224EA690ED1128', 'Presentations', '<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Lucida Grande; color: #333333">Presso</p>', '2011-02-18 00:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('40288110380cda3301382644c7f90008', 'LM', 'LM<br>', '2012-06-10 23:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('402881882814615e012826481061000c', 'Marc', 'This is marcs category<br>', '2010-04-21 22:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('402881882814615e01282bb047fd001e', 'Cool Wow', 'A cool wow category<br>', '2010-04-22 22:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('402881882b89b49b012b9201bda80002', 'PascalNews', 'PascalNews', '2010-10-09 00:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('402881a144f57bfd0144fa47bf040007', 'ads', 'asdf', '2014-01-25 00:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('5898F818-A9B6-4F5D-96FE70A31EBB78AC', 'Release', '<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Lucida Grande; color: #333333">Releases</p>', '2009-04-18 11:48:53', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('88B689EA-B1C0-8EEF-143A84813ACADA35', 'general', 'A general category', '2010-03-31 12:53:21', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('88B689EA-B1C0-8EEF-143A84813BCADA35', 'general', 'A second test general category', '2010-03-31 12:53:21', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('88B6C087-F37E-7432-A13A84D45A0F703B', 'News', 'A news cateogyr', '2009-04-18 11:48:53', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('99fc94fd3b98c834013b98c9b2140002', 'Fancy', 'Fancy Editor<br>', '2012-12-14 00:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('99fc94fd3b9a459d013b9db89c060002', 'Markus', 'Hello Markus<br>', '2012-12-14 15:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91', 'Training', 'unittest', '2014-05-07 19:05:21', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('ff80808128c9fa8b0128cc3af5d90007', 'Geeky Stuff', 'Geeky Stuff', '2010-05-25 16:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('ff80808128c9fa8b0128cc3b20bf0008', 'ColdBox', 'ColdBox', '2010-05-23 16:00:00', NULL);
INSERT INTO "public"."categories" ("category_id", "category", "description", "modifydate", "testValue") VALUES ('ff80808128c9fa8b0128cc3b7cdd000a', 'ColdFusion', 'ColdFusion', '2010-05-23 16:00:00', NULL);
COMMIT;

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS "public"."comments";
CREATE TABLE "public"."comments" (
  "comment_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "FKentry_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "comment" text COLLATE "pg_catalog"."default" NOT NULL,
  "time" timestamp(6) NOT NULL
)
;
ALTER TABLE "public"."comments" OWNER TO "cborm";

-- ----------------------------
-- Records of comments
-- ----------------------------
BEGIN;
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('40288110380cda330138265bf9c4000a', '8a64b3712e3a0a5e012e3a11a2cf0004', 'tt', '2012-06-12 23:00:00');
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('40288110380cda3301382c7fe50d0012', '88B82629-B264-B33E-D1A144F97641614E', 'Test', '2012-06-06 23:00:00');
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('402881882814615e01282b13bbc20013', '88B82629-B264-B33E-D1A144F97641614E', 'This entire blog post really offended me, I hate you', '2010-04-22 22:00:00');
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('402881882814615e01282b13fb290014', '88B82629-B264-B33E-D1A144F97641614E', 'Why are you so hurtful man!', '2010-04-22 22:00:00');
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('402881882814615e01282b142cc60015', '88B82629-B264-B33E-D1A144F97641614E', 'La realidad, que barbaro!', '2010-04-22 22:00:00');
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('88B8C6C7-DFB7-0F34-C2B0EFA4E5D7DA4C', '88B82629-B264-B33E-D1A144F97641614E', 'this blog sucks.', '2010-09-02 11:39:04');
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('8a64b3712e3a0a5e012e3a10321d0002', '402881882814615e01282b14964d0016', 'Vlad is awesome!', '2011-02-18 00:00:00');
INSERT INTO "public"."comments" ("comment_id", "FKentry_id", "comment", "time") VALUES ('8a64b3712e3a0a5e012e3a12b1d10005', '8a64b3712e3a0a5e012e3a11a2cf0004', 'Vlad is awesome!', '2011-02-18 00:00:00');
COMMIT;

-- ----------------------------
-- Table structure for contact
-- ----------------------------
DROP TABLE IF EXISTS "public"."contact";
CREATE TABLE "public"."contact" (
  "id" int4 NOT NULL,
  "firstName" varchar(255) COLLATE "pg_catalog"."default",
  "lastName" varchar(255) COLLATE "pg_catalog"."default",
  "email" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."contact" OWNER TO "cborm";

-- ----------------------------
-- Records of contact
-- ----------------------------
BEGIN;
INSERT INTO "public"."contact" ("id", "firstName", "lastName", "email") VALUES (1, 'Luis', 'Majano', 'lmajano@ortussolutions.com');
INSERT INTO "public"."contact" ("id", "firstName", "lastName", "email") VALUES (2, 'Jorge', 'Reyes', 'lmajano@gmail.com');
INSERT INTO "public"."contact" ("id", "firstName", "lastName", "email") VALUES (3, '', '', '');
COMMIT;

-- ----------------------------
-- Table structure for entries
-- ----------------------------
DROP TABLE IF EXISTS "public"."entries";
CREATE TABLE "public"."entries" (
  "entry_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "entryBody" text COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "postedDate" timestamp(6) NOT NULL,
  "FKuser_id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."entries" OWNER TO "cborm";
COMMENT ON TABLE "public"."entries" IS 'InnoDB free: 9216 kB; (`FKuser_id`) REFER `coolblog/users`(`';

-- ----------------------------
-- Records of entries
-- ----------------------------
BEGIN;
INSERT INTO "public"."entries" ("entry_id", "entryBody", "title", "postedDate", "FKuser_id") VALUES ('402881882814615e01282b14964d0016', 'Wow, welcome to my new blog, enjoy your stay<br>', 'My awesome post', '2010-04-22 22:00:00', '88B73A03-FEFA-935D-AD8036E1B7954B76');
INSERT INTO "public"."entries" ("entry_id", "entryBody", "title", "postedDate", "FKuser_id") VALUES ('88B82629-B264-B33E-D1A144F97641614E', 'A first cool blog,hope it does not crash', 'A cool blog first posting', '2009-04-08 00:00:00', '88B73A03-FEFA-935D-AD8036E1B7954B76');
INSERT INTO "public"."entries" ("entry_id", "entryBody", "title", "postedDate", "FKuser_id") VALUES ('8a64b3712e3a0a5e012e3a11a2cf0004', 'ContentBox is a professional open source modular content management engine that allows you to easily build websites adfsadf adfsadf asfddasfddasfddasfdd', 'My First Awesome Post My First Awesome Post', '2013-04-16 22:00:00', '88B73A03-FEFA-935D-AD8036E1B7954B76');
INSERT INTO "public"."entries" ("entry_id", "entryBody", "title", "postedDate", "FKuser_id") VALUES ('8aee965b3cfff278013d0007d9540002', '<span>Mobile browsing popularity is skyrocketing. &nbsp;According to a <a href="http://www.nbcnews.com/technology/technolog/25-percent-use-smartphones-not-computers-majority-web-surfing-122259">new Pew Internet Project report</a>, 25% of Americans use smartphones instead of computers for the majority of their web browsing.</span>
<span>Missing out on <a href="http://guavabox.com/3-ways-to-get-started-with-mobile-marketing/">the mobile marketing trend</a>&nbsp;is
 likely to translate into loss of market share and decreased sales. 
That’s not to say that it’s right for every business, but you at least 
need to consider your target market persona before simply dismissing 
mobile as a fad.</span>
One simple step you can take in the mobile direction is to learn how to add Apple icons to your website.
<h2>What Are Apple Icons &amp; Why Use Them?</h2>
<span><a href="http://guavabox.com/wp-content/uploads/2013/02/guavabox-apple-icon.png"><img src="http://guavabox.com/wp-content/uploads/2013/02/guavabox-apple-icon.png" alt="GuavaBox Apple Icon Example" height="246" width="307"></a>Apple
 Icons are simply the graphics you’ve chosen to represent your site when
 a user saves your page to their home screen in iOS.</span>
If you don’t have Apple Icons created for your site, iOS grabs a 
compressed thumbnail of your website and displays it as the icon. &nbsp;The 
result is typically indistinguishable and unappealing.
Apple Icons are an awesome branding opportunity and give you the chance to g<br>', 'Test', '2013-04-23 00:00:00', '402884cc310b1ae901311be89381000a');
INSERT INTO "public"."entries" ("entry_id", "entryBody", "title", "postedDate", "FKuser_id") VALUES ('99fc94fd3ba7f266013bad4a8a3b0004', 'This is my first blog post from Bern!<br>', 'This is my first blog post from Bern!', '2012-12-17 15:00:00', '99fc94fd3ba7f266013bad49e3c50003');
COMMIT;

-- ----------------------------
-- Table structure for entry_categories
-- ----------------------------
DROP TABLE IF EXISTS "public"."entry_categories";
CREATE TABLE "public"."entry_categories" (
  "FKcategory_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "FKentry_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."entry_categories" OWNER TO "cborm";

-- ----------------------------
-- Records of entry_categories
-- ----------------------------
BEGIN;
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('88B689EA-B1C0-8EEF-143A84813ACADA35', '88B82629-B264-B33E-D1A144F97641614E');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('88B6C087-F37E-7432-A13A84D45A0F703B', '88B82629-B264-B33E-D1A144F97641614E');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('3A2C516C-41CE-41D3-A9224EA690ED1128', '99fc94fd3ba7f266013bad4a8a3b0004');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('5898F818-A9B6-4F5D-96FE70A31EBB78AC', '99fc94fd3ba7f266013bad4a8a3b0004');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('99fc94fd3b98c834013b98c9b2140002', '99fc94fd3ba7f266013bad4a8a3b0004');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('5898F818-A9B6-4F5D-96FE70A31EBB78AC', '402881882814615e01282b14964d0016');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('40288110380cda3301382644c7f90008', '402881882814615e01282b14964d0016');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('3A2C516C-41CE-41D3-A9224EA690ED1128', '402881882814615e01282b14964d0016');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('402881882b89b49b012b9201bda80002', '402881882814615e01282b14964d0016');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('99fc94fd3b98c834013b98c9b2140002', '402881882814615e01282b14964d0016');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('5898F818-A9B6-4F5D-96FE70A31EBB78AC', '8a64b3712e3a0a5e012e3a11a2cf0004');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91', '8a64b3712e3a0a5e012e3a11a2cf0004');
INSERT INTO "public"."entry_categories" ("FKcategory_id", "FKentry_id") VALUES ('3A2C516C-41CE-41D3-A9224EA690ED1128', '8a64b3712e3a0a5e012e3a11a2cf0004');
COMMIT;

-- ----------------------------
-- Table structure for logs
-- ----------------------------
DROP TABLE IF EXISTS "public"."logs";
CREATE TABLE "public"."logs" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "severity" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "category" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "logdate" timestamp(6) NOT NULL,
  "appendername" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "message" text COLLATE "pg_catalog"."default",
  "extrainfo" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."logs" OWNER TO "cborm";

-- ----------------------------
-- Records of logs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for relax_logs
-- ----------------------------
DROP TABLE IF EXISTS "public"."relax_logs";
CREATE TABLE "public"."relax_logs" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "severity" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "category" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "logdate" timestamp(6) NOT NULL,
  "appendername" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "message" text COLLATE "pg_catalog"."default",
  "extrainfo" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."relax_logs" OWNER TO "cborm";

-- ----------------------------
-- Records of relax_logs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS "public"."roles";
CREATE TABLE "public"."roles" (
  "roleID" int4 NOT NULL,
  "role" varchar(100) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."roles" OWNER TO "cborm";

-- ----------------------------
-- Records of roles
-- ----------------------------
BEGIN;
INSERT INTO "public"."roles" ("roleID", "role") VALUES (1, 'Administrator');
INSERT INTO "public"."roles" ("roleID", "role") VALUES (2, 'Moderator');
INSERT INTO "public"."roles" ("roleID", "role") VALUES (3, 'Anonymous');
INSERT INTO "public"."roles" ("roleID", "role") VALUES (4, 'Super User');
INSERT INTO "public"."roles" ("roleID", "role") VALUES (5, 'Editor');
COMMIT;

-- ----------------------------
-- Table structure for todo
-- ----------------------------
DROP TABLE IF EXISTS "public"."todo";
CREATE TABLE "public"."todo" (
  "blogsID" int4 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."todo" OWNER TO "cborm";

-- ----------------------------
-- Records of todo
-- ----------------------------
BEGIN;
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (1, 'AL-{ts ''2011-04-07 11:15:55''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (2, 'AL-{ts ''2011-04-07 11:16:22''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (3, 'AL-{ts ''2011-04-07 11:17:06''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (4, 'AL-{ts ''2011-04-07 11:21:52''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (5, 'AL-{ts ''2011-04-07 11:23:06''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (6, 'AL-{ts ''2011-04-07 11:23:08''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (7, 'AL-{ts ''2011-04-18 17:23:59''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (8, 'AL-{ts ''2011-04-18 17:37:15''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (9, 'AL-{ts ''2011-04-18 17:37:20''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (10, 'AL-{ts ''2011-04-18 17:38:06''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (11, 'AL-{ts ''2011-04-18 17:38:08''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (12, 'AL-{ts ''2011-04-18 17:38:09''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (13, 'AL-{ts ''2011-04-18 17:38:10''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (14, 'AL-{ts ''2011-04-18 17:38:11''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (15, 'AL-{ts ''2011-04-18 17:38:12''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (16, 'AL-{ts ''2011-04-18 17:38:14''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (17, 'AL-{ts ''2011-04-18 17:38:15''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (18, 'AL-{ts ''2011-04-18 17:38:16''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (19, 'AL-{ts ''2011-04-18 17:38:17''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (20, 'AL-{ts ''2011-04-18 17:38:18''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (21, 'AL-{ts ''2011-04-18 17:38:19''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (22, 'AL-{ts ''2011-04-18 17:38:20''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (23, 'AL-{ts ''2011-04-18 17:38:21''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (24, 'AL-{ts ''2011-04-18 17:40:41''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (25, 'AL-{ts ''2011-04-18 17:40:44''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (26, 'AL-{ts ''2011-04-18 17:40:47''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (27, 'AL-{ts ''2011-04-18 17:41:38''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (28, 'AL-{ts ''2011-04-18 17:44:15''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (29, 'AL-{ts ''2011-04-18 17:44:25''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (30, 'AL-{ts ''2011-04-18 17:44:39''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (31, 'AL-{ts ''2011-04-18 17:49:44''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (32, 'AL-{ts ''2011-04-18 17:50:10''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (33, 'AL-{ts ''2011-04-18 17:51:07''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (34, 'AL-{ts ''2011-04-18 17:57:44''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (35, 'AL-{ts ''2011-04-18 18:03:33''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (36, 'AL-{ts ''2011-04-18 19:32:04''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (37, 'AL-{ts ''2011-04-18 19:32:08''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (38, 'AL-{ts ''2011-04-18 19:32:31''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (39, 'AL-{ts ''2011-04-18 19:32:51''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (40, 'AL-{ts ''2011-04-18 20:02:55''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (41, 'AL-{ts ''2011-04-18 20:03:52''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (42, 'AL-{ts ''2011-04-18 20:04:10''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (43, 'AL-{ts ''2011-04-18 20:12:52''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (44, 'AL-{ts ''2011-04-19 15:43:36''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (45, 'AL-{ts ''2011-04-19 15:44:20''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (46, 'AL-{ts ''2011-04-19 15:48:26''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (47, 'AL-{ts ''2011-04-19 15:50:59''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (48, 'AL-{ts ''2011-04-19 15:51:08''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (49, 'AL-{ts ''2011-04-19 15:51:15''}');
INSERT INTO "public"."todo" ("blogsID", "name") VALUES (50, 'AL-{ts ''2011-04-23 12:58:04''}');
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
  "user_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "firstName" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "lastName" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "userName" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "lastLogin" timestamp(6),
  "FKRoleID" int4,
  "isActive" varchar(1) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."users" OWNER TO "cborm";

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO "public"."users" ("user_id", "firstName", "lastName", "userName", "password", "lastLogin", "FKRoleID", "isActive") VALUES ('4028818e2fb6c893012fe637c5db00a7', 'George', 'Form Injector', 'george', 'george', NULL, 2, '1');
INSERT INTO "public"."users" ("user_id", "firstName", "lastName", "userName", "password", "lastLogin", "FKRoleID", "isActive") VALUES ('402884cc310b1ae901311be89381000a', 'ken', 'Advanced Guru', 'kenneth', 'smith', '2014-03-25 00:00:00', 2, '1');
INSERT INTO "public"."users" ("user_id", "firstName", "lastName", "userName", "password", "lastLogin", "FKRoleID", "isActive") VALUES ('4A386F4D-DCF4-6587-7B89B3BD57C97155', 'Joe', 'Fernando', 'joe', 'joe', '2009-05-15 00:00:00', 1, '1');
INSERT INTO "public"."users" ("user_id", "firstName", "lastName", "userName", "password", "lastLogin", "FKRoleID", "isActive") VALUES ('88B73A03-FEFA-935D-AD8036E1B7954B76', 'Luis', 'Majano', 'lui', 'lmajano', '2009-04-08 00:00:00', 1, '1');
INSERT INTO "public"."users" ("user_id", "firstName", "lastName", "userName", "password", "lastLogin", "FKRoleID", "isActive") VALUES ('8a64b3712e3a0a5e012e3a110fab0003', 'Vladymir', 'Ugryumov', 'vlad', 'vlad', '2011-02-18 00:00:00', 1, '1');
INSERT INTO "public"."users" ("user_id", "firstName", "lastName", "userName", "password", "lastLogin", "FKRoleID", "isActive") VALUES ('99fc94fd3b98c834013b98c928120001', 'Juerg', 'Anderegg', 'juerg', 'juerg', '2012-12-14 00:00:00', NULL, '1');
INSERT INTO "public"."users" ("user_id", "firstName", "lastName", "userName", "password", "lastLogin", "FKRoleID", "isActive") VALUES ('99fc94fd3ba7f266013bad49e3c50003', 'Tanja', 'Zogg', 'tanja', 'tanja', '2012-12-18 00:00:00', NULL, '1');
COMMIT;

-- ----------------------------
-- Indexes structure for table blogEntries
-- ----------------------------
CREATE INDEX "FK2828728E45296FD" ON "public"."blogEntries" USING btree (
  "blogsID" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table blogEntries
-- ----------------------------
ALTER TABLE "public"."blogEntries" ADD CONSTRAINT "blogEntries_pkey" PRIMARY KEY ("blogEntriesID");

-- ----------------------------
-- Primary Key structure for table blogs
-- ----------------------------
ALTER TABLE "public"."blogs" ADD CONSTRAINT "blogs_pkey" PRIMARY KEY ("blogsID");

-- ----------------------------
-- Primary Key structure for table cacheBox
-- ----------------------------
ALTER TABLE "public"."cacheBox" ADD CONSTRAINT "cacheBox_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table categories
-- ----------------------------
ALTER TABLE "public"."categories" ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("category_id");

-- ----------------------------
-- Indexes structure for table comments
-- ----------------------------
CREATE INDEX "FK_comments_1" ON "public"."comments" USING btree (
  "FKentry_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "FKentry_id" ON "public"."comments" USING btree (
  "FKentry_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table comments
-- ----------------------------
ALTER TABLE "public"."comments" ADD CONSTRAINT "comments_pkey" PRIMARY KEY ("comment_id");

-- ----------------------------
-- Primary Key structure for table contact
-- ----------------------------
ALTER TABLE "public"."contact" ADD CONSTRAINT "contact_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table entries
-- ----------------------------
CREATE INDEX "FKuser_id" ON "public"."entries" USING btree (
  "FKuser_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table entries
-- ----------------------------
ALTER TABLE "public"."entries" ADD CONSTRAINT "entries_pkey" PRIMARY KEY ("entry_id");

-- ----------------------------
-- Indexes structure for table entry_categories
-- ----------------------------
CREATE INDEX "FKcategory_id" ON "public"."entry_categories" USING btree (
  "FKcategory_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
