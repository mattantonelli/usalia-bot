# Usalia Bot

Usalia is a Discord bot intended to provide useful functionality to your Discord server. Powered by [discordrb](https://github.com/meew0/discordrb).

## Installation

Usalia is currently a private bot. You will need to create and run your own Discord app to add her to your server.

1. [Create a new Discord app](https://discordapp.com/developers/applications/me)
2. Click "Create a Bot User"
3. Insert your client ID into the following URL: `https://discordapp.com/oauth2/authorize?client_id=INSERT_CLIENT_ID_HERE&scope=bot&permissions=268512336`
4. Follow the URL to add the bot to your server (requires the Manage Server permission)
5. `git clone https://github.com/mattantonelli/usalia-bot`
6. `cd usalia-bot`
7. `bundle install`
8. Set up the configuration file
    * `cp config/config.yml.example config/config.yml`
    * Updated the example values appropriately
9. `ruby usalia.rb`

## Permissions

Usalia requires the following permissions to work in a channel:

* Manage Roles
* Manage Channels
* Read Messages
* Send Messages
* Manage Messages
* Read Message History
* Add Reactions

## Deployment

Usalia is set up for [Capistrano](https://github.com/capistrano/capistrano) deployment. The deployment strategy is dependent on `rbenv` and `screen`. You can configure Usalia to deploy to your own server by updating `config/deploy.rb` and `config/deploy/production.rb` appropriately.

## Functions
### Poll
#### Description
Creates a poll by adding reactions to any message starting with `/poll`. The :thumbsup: and :thumbsdown: reactions are added by default, but you can add your own emojis to the message to use those instead.

#### Examples
`/poll Metal Gear Solid 2 is the best MGS title.`

`/poll Would you rather go for :coffee: or :ice_cream: ?`

![Poll](http://i.imgur.com/PJfbKDN.png)

### Convert
#### Description
Converts time from one zone to another. This command tries to be smart about DST, and will correct the given zones appropriately (e.g. EST when it is actually EDT.) This command currently supports the continental US, the UK, and southeastern Australia.

#### Examples
`@Usalia convert 8:00am EST to GMT`

`@Usalia convert 14:00 PST to EST`

![Convert](http://i.imgur.com/BottAdX.png)

### Random
#### Description
Rolls a random number from 1 to 999.

#### Examples
`@Usalia random`

![Random](http://i.imgur.com/o84Vktm.png)

### Ready Check
#### Description
Initiates a ready check for the mentioned users/roles. Users have 30 seconds to confirm they are ready by selecting a reaction on the bot's response message.

#### Examples
`@Usalia ready @user1 @user2`

`@Usalia ready @role1 @role2`

![Ready](http://i.imgur.com/BTmTHMv.png)


### Request
#### Description
A request is a call for help that can be issued by users with the configured Officer role when they react to a message with :bell: in any of the configured Request Channels. When Usalia sees the bell reaction added under these criteria, she will react to the message with the configured request reactions. An Officer can have the bot mention any users who reacted to the message by adding the :mega: reaction.

#### Examples
![Request](http://i.imgur.com/IfeRFVS.png)

### Introductions
#### Description
Welcomes new members to the server in the configured Introductions channel.

#### Examples
![Introductions](http://i.imgur.com/kMmEn17.png)

### Party
#### Description
Creates a temporary voice channel for the user's in game party members. Temporary channels are deleted after an hour if nobody is connected to the channel. A maximum of five channels can be active at a time.

#### Examples
![Party](http://i.imgur.com/dLLEsuA.png)
