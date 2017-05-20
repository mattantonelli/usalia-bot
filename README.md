# Usalia Bot

Usalia is a Discord bot intended to provide useful functionality to your Discord server. Powered by [discordrb](https://github.com/meew0/discordrb).

## Installation

Usalia is currently a private bot. You will need to create and run your own Discord app to add her to your server.

1. [Create a new Discord app](https://discordapp.com/developers/applications/me)
2. Click "Create a Bot User"
3. Insert your client ID into the following URL: `https://discordapp.com/oauth2/authorize?client_id=INSERT_CLIENT_ID_HERE&scope=bot&permissions=68672`
4. Follow the URL to add the bot to your server (requires the Manage Server permission)
5. `git clone https://github.com/mattantonelli/usalia-bot`
6. `cd usalia-bot`
7. `bundle install`
8. Set up the configuration file
    * `cp .env.example .env`
    * Replace the client_id and token with the ones generated for your bot user
    * Replace the owner_id with the one for your user
9. `ruby usalia.rb`

## Permissions

Usalia requires the following permissions to work in a channel:

* Read Messages
* Send Messages
* Read Message History
* Add Reactions

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
