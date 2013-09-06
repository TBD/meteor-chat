console.log 'server start'

# cleanup
Messages.remove({})

# start items
Messages.insert
	text: 'hello world'
	avatar: ''

# publish all
Meteor.publish 'messages', ->
	Messages.find()

Meteor.publish null, ->
	Meteor.users.find {},
	    fields:
	        username: 1
	        profile: 1

Meteor.methods
	'addMessage': (message) ->
		if message
			user = Meteor.user()
			avatar = 'img/anon.png'
			if user? and user.services?
				avatar = user.services.google.picture
			Messages.insert {
				text: message
				avatar: avatar
			}
			message = ''