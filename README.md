# Usalia Bot

Usalia is a Discord bot intended to provide useful functionality to your Discord server.

## Installation

Usalia is currently a private bot. You will need to create and run your own Discord app to add her to your server.

1. [Create a new Discord app](https://discordapp.com/developers/applications/me)
2. Click "Create a Bot User"
3. Insert your client ID into the following URL: `https://discordapp.com/oauth2/authorize?client_id=INSERT_CLIENT_ID_HERE&scope=bot&permissions=68672` 
4. Follow the URL to add the bot to your server (requires the Manage Server permission)
5. Set up the configuration file
  * `cp config/app.yml.example config/app.yml`
  * Replace the client_id and token with the ones generated for your bot user
6. `ruby usalia.rb`

## Permissions

Usalia requires the following permissions to work in a channel:

* Read Messages
* Send Messages
* Read Message History
* Add Reactions

## Functions
### Polls
#### Description
Creates a poll by adding reactions to any message starting with `/poll`. The :thumbsup: and :thumbsdown: reactions are added by default, but you can add your own emojis to the message to use those instead.

#### Examples
`/poll Metal Gear Solid 2 is the best MGS title.`

:thumbsup: :thumbsdown:

`/poll Would you rather go for :coffee: or :ice_cream: ?`

:coffee: :ice_cream:

![Poll](http://imgur.com/J980x2a.gif)
