# Usalia Bot

Usalia is a Discord bot intended to provide useful functionality to your Discord server. Powered by [discordrb](https://github.com/meew0/discordrb).

## Installation

Usalia is currently a private bot. You will need to create and run your own Discord app to add her to your server.

1. [Create a new Discord app](https://discordapp.com/developers/applications/me)
2. Click "Create a Bot User"
3. Insert your client ID into the following URL: `https://discordapp.com/oauth2/authorize?client_id=INSERT_CLIENT_ID_HERE&scope=bot&permissions=268659792`
4. Follow the URL to add the bot to your server (requires the Manage Server permission)
5. `git clone https://github.com/mattantonelli/usalia-bot`
6. `cd usalia-bot`
7. `bundle install`
8. Set up the configuration file
    * `cp config/config.yml.example config/config.yml`
    * Updated the example values appropriately
9. `bundle exec ruby run.rb`

## Permissions

Usalia requires the following permissions:

* Manage Roles
* Manage Channels
* Read Text Channels & See Voice Channels
* Send Messages
* Manage Messages
* Embed Links
* Read Message History
* Mention Everyone
* Add Reactions

## Deployment

Usalia is set up for [Capistrano](https://github.com/capistrano/capistrano) deployment. The deployment strategy is dependent on `rbenv` and `screen`. You can configure Usalia to deploy to your own server by updating `config/deploy.rb` and `config/deploy/production.rb` appropriately.

## Functions
### Poll
#### Description
Creates a poll by adding reactions to the command message. The :thumbsup: and :thumbsdown: reactions are added by default, but you can add your own emojis to the message to use those instead.

#### Usage
`@Usalia poll Metal Gear Solid 2 is the best MGS title.`

`@Usalia poll Would you rather go for :coffee: or :ice_cream: ?`

### Convert
#### Description
Converts time from one zone to another. This command tries to be smart about DST, and will correct the given zones appropriately (e.g. EST when it is actually EDT.) This command currently supports the continental US, the UK, and southeastern Australia.

#### Usage
`@Usalia convert 8:00am EST to GMT`

`@Usalia convert 14:00 PST to EST`

### Random
#### Description
Rolls a random number from 1 to 999.

#### Usage
`@Usalia random`

### Ready Check
#### Description
Initiates a ready check for the mentioned users/roles. Users have 30 seconds to confirm they are ready by selecting a reaction on the bot's response message.

#### Usage
`@Usalia ready @user1 @user2`

`@Usalia ready @role1 @role2`

### Request
#### Description
A request is a call for help that can be issued by users with the **Mention Everyone** permission  when they react to a message with :bell: in any of the configured Request Channels. When Usalia sees the bell reaction added under these criteria, she will react to the message with the configured request reactions. A user with the **Mention Everyone** permission can also have the bot mention any users who reacted to the message by adding the :mega: reaction.

### Introductions
#### Description
Welcomes new members to the server in the configured Introductions channel.

### Party
#### Description
Creates a temporary voice channel for the user's in game party members. Temporary channels are deleted after an hour if nobody is connected to the channel. A maximum of five channels can be active at a time.

To create a private channel, mention at least one other user. A temporary role will be assigned to the author and all mentioned users that will allow access to the channel.

#### Usage
`@Usalia party`

`@Usalia party @user1 @user2`

### Disband
#### Description
Disbands your party.

#### Usage
`@Usalia disband`

### Yu-Gi-Oh!
#### Description
Looks up a Yu-Gi-Oh! card by name. All of the card's major information is provided as an embed, and a link is provided to the full-sized card image.

Card data provided by the [Yu-Gi-Oh Prices](https://yugiohprices.com/) [API](http://docs.yugiohprices.apiary.io/#).

#### Usage
`@Usalia yugioh blue-eyes white dragon`

### Stream
#### Description
Broadcasts when a user starts streaming using the Twitch connection. Updates are sent to the configured Twitch channel after a user has enabled the feature for their account.

#### Usage
`@Usalia stream <on/off/status>`

### Twitch
#### Description
Similar to the Stream command, but for specific Twitch users. These stream updates can be configured by an admin user.

#### Usage
`@Usalia twitch <username> <on/off/status>`

### FF Logs
#### Description
Posts FF Logs reports for users in their configured channels after they are uploaded. Logs must be uploaded within 24 hours after their start time. Logs for a given user can be posted in a single channel, as configured by an admin via commands.

#### Usage
`@Usalia fflogs <owner> <on/off/status>`

### YouTube
#### Description
Posts the top YouTube search result for the given query.

#### Usage
`@Usalia youtube <query>`

### Temperature
#### Description
Converts between Celsius and Fahrenheit.

#### Usage
`@Usalia temp <value> <C/F>`

### Magic: The Gathering
#### Description
Looks up a Magic: The Gathering card by name. All of the card's major information is provided as an embed, and a link is provided to the full-sized card image.

Card data provided by [Magic: The Gathering - Developers](https://magicthegathering.io/).

#### Usage
`@Usalia mtg chandra, fire of kaladesh`

### Skeleton
Posts a random skeleton GIF by [jjjjjohn](https://giphy.com/jjjjjohn).

#### Usage
`@Usalia skeleton`
